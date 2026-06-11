//
//  WeatherLocalDataSourceImpl.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import CoreData
import Combine

class WeatherLocalDataSourceImpl: WeatherLocalDataSource {

    private let coreDataManager: CoreDataManager
    private let currentCacheThreshold: TimeInterval = 30 * 60      // 30 minutes
    private let forecastCacheThreshold: TimeInterval = 3 * 60 * 60 // 3 hours

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Fetch Cached Bundle

    func fetchCachedBundle(for location: String) -> AnyPublisher<WeatherBundle?, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            let context = self.coreDataManager.viewContext

            let currentRequest = CachedCurrentWeather.fetchRequest()
            currentRequest.predicate = NSPredicate(format: "location == %@", location)
            currentRequest.fetchLimit = 1

            do {
                guard let cached = try context.fetch(currentRequest).first else {
                    promise(.success(nil))
                    return
                }

                let currentAge = Date().timeIntervalSince(cached.cachedAt ?? Date.distantPast)
                if currentAge > self.currentCacheThreshold {
                    promise(.success(nil))
                    return
                }

                let dailyRequest = CachedDailyWeather.fetchRequest()
                dailyRequest.predicate = NSPredicate(format: "locationKey == %@", location)
                let cachedDays = try context.fetch(dailyRequest)

                if let firstDay = cachedDays.first {
                    let forecastAge = Date().timeIntervalSince(firstDay.cachedAt ?? Date.distantPast)
                    if forecastAge > self.forecastCacheThreshold {
                        promise(.success(nil))
                        return
                    }
                }

                let hourlyRequest = CachedHourlyWeather.fetchRequest()
                hourlyRequest.predicate = NSPredicate(format: "locationKey == %@", location)
                let cachedHours = try context.fetch(hourlyRequest)

                let bundle = self.mapToBundle(
                    current: cached,
                    days: cachedDays,
                    hours: cachedHours
                )
                promise(.success(bundle))

            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Save Bundle

    func saveBundle(_ bundle: WeatherBundle) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            let context = self.coreDataManager.backgroundContext

            context.perform {
                do {
                    let locationKey = bundle.current.location

                    // Delete old cached data
                    self.deleteExisting(CachedCurrentWeather.fetchRequest(), predicate: NSPredicate(format: "location == %@", locationKey), context: context)
                    self.deleteExisting(CachedDailyWeather.fetchRequest(), predicate: NSPredicate(format: "locationKey == %@", locationKey), context: context)
                    self.deleteExisting(CachedHourlyWeather.fetchRequest(), predicate: NSPredicate(format: "locationKey == %@", locationKey), context: context)

                    // Save current
                    let current = CachedCurrentWeather(context: context)
                    current.location = locationKey
                    current.temperature = bundle.current.temperature
                    current.feelsLike = bundle.current.feelsLike
                    current.conditionCode = Int32(bundle.current.conditionCode)
                    current.condition = bundle.current.condition
                    current.iconURL = bundle.current.iconURL
                    current.humidity = Int32(bundle.current.humidity)
                    current.pressure = bundle.current.pressure
                    current.visibility = bundle.current.visibility
                    current.isDay = bundle.current.isDay
                    current.lat = bundle.current.lat
                    current.lon = bundle.current.lon
                    current.cachedAt = Date()

                    // Save forecast days + hours
                    for day in bundle.forecast {
                        let cachedDay = CachedDailyWeather(context: context)
                        cachedDay.date = day.date
                        cachedDay.dayLabel = day.dayLabel
                        cachedDay.maxTemp = day.maxTemp
                        cachedDay.minTemp = day.minTemp
                        cachedDay.conditionCode = Int32(day.conditionCode)
                        cachedDay.condition = day.condition
                        cachedDay.iconURL = day.iconURL
                        cachedDay.locationKey = locationKey
                        cachedDay.cachedAt = Date()

                        for hour in day.hours {
                            let cachedHour = CachedHourlyWeather(context: context)
                            cachedHour.time = hour.time
                            cachedHour.timeLabel = hour.timeLabel
                            cachedHour.temp = hour.temperature
                            cachedHour.conditionCode = Int32(hour.conditionCode)
                            cachedHour.condition = hour.condition
                            cachedHour.iconURL = hour.iconURL
                            cachedHour.isDay = hour.isDay
                            cachedHour.dayDate = day.date
                            cachedHour.locationKey = locationKey
                        }
                    }

                    self.coreDataManager.save(context: context)
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Saved Locations

    func fetchSavedLocations() -> AnyPublisher<[SavedLocation], Error> {
        Future { [weak self] promise in
            guard let self else { return }
            let context = self.coreDataManager.viewContext
            let request = SavedLocationEntity.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "savedAt", ascending: false)
            request.sortDescriptors = [sortDescriptor]

            do {
                let results = try context.fetch(request)
                let locations = results.map { self.mapToSavedLocation($0) }
                promise(.success(locations))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func saveLocation(_ bundle: WeatherBundle) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            let context = self.coreDataManager.backgroundContext

            context.perform {
                let request = SavedLocationEntity.fetchRequest()
                request.predicate = NSPredicate(format: "location == %@", bundle.current.location)

                do {
                    let existing = try context.fetch(request)
                    existing.forEach { context.delete($0) }

                    let saved = SavedLocationEntity(context: context)
                    saved.location = bundle.current.location
                    saved.temperature = bundle.current.temperature
                    saved.feelsLike = bundle.current.feelsLike
                    saved.conditionCode = Int32(bundle.current.conditionCode)
                    saved.condition = bundle.current.condition
                    saved.iconURL = bundle.current.iconURL
                    saved.humidity = Int32(bundle.current.humidity)
                    saved.pressure = bundle.current.pressure
                    saved.lat = bundle.current.lat
                    saved.lon = bundle.current.lon
                    saved.savedAt = Date()

                    self.coreDataManager.save(context: context)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func removeLocation(named location: String) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            let context = self.coreDataManager.backgroundContext

            context.perform {
                let request = SavedLocationEntity.fetchRequest()
                request.predicate = NSPredicate(format: "location == %@", location)

                do {
                    let results = try context.fetch(request)
                    results.forEach { context.delete($0) }
                    self.coreDataManager.save(context: context)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func isLocationSaved(named location: String) -> AnyPublisher<Bool, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            let context = self.coreDataManager.viewContext
            let request = SavedLocationEntity.fetchRequest()
            request.predicate = NSPredicate(format: "location == %@", location)
            request.fetchLimit = 1

            do {
                let count = try context.fetch(request).count
                promise(.success(count > 0))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Private Helpers

    private func deleteExisting<T: NSManagedObject>(_ request: NSFetchRequest<T>, predicate: NSPredicate, context: NSManagedObjectContext) {
        request.predicate = predicate
        if let results = try? context.fetch(request) {
            results.forEach { context.delete($0) }
        }
    }

    private func mapToBundle(
        current: CachedCurrentWeather,
        days: [CachedDailyWeather],
        hours: [CachedHourlyWeather]
    ) -> WeatherBundle {
        let currentWeather = CurrentWeather(
            location: current.location ?? "",
            temperature: current.temperature,
            feelsLike: current.feelsLike,
            conditionCode: Int(current.conditionCode),
            condition: current.condition ?? "",
            iconURL: current.iconURL ?? "",
            humidity: Int(current.humidity),
            pressure: current.pressure,
            visibility: current.visibility,
            isDay: current.isDay,
            lat: current.lat,
            lon: current.lon
        )

        let forecast: [DailyWeather] = days.map { day in
            let dayHours = hours
                .filter { $0.dayDate == day.date }
                .map { hour in
                    HourlyWeather(
                        time: hour.time ?? "",
                        timeLabel: hour.timeLabel ?? "",
                        temperature: hour.temp,
                        conditionCode: Int(hour.conditionCode),
                        condition: hour.condition ?? "",
                        iconURL: hour.iconURL ?? "",
                        isDay: hour.isDay
                    )
                }

            return DailyWeather(
                date: day.date ?? "",
                dayLabel: day.dayLabel ?? "",
                maxTemp: day.maxTemp,
                minTemp: day.minTemp,
                conditionCode: Int(day.conditionCode),
                condition: day.condition ?? "",
                iconURL: day.iconURL ?? "",
                hours: dayHours
            )
        }

        return WeatherBundle(
            current: currentWeather,
            forecast: forecast,
            isDay: current.isDay
        )
    }

    private func mapToSavedLocation(_ entity: SavedLocationEntity) -> SavedLocation {
        SavedLocation(
            location: entity.location ?? "",
            temperature: entity.temperature,
            feelsLike: entity.feelsLike,
            conditionCode: Int(entity.conditionCode),
            condition: entity.condition ?? "",
            iconURL: entity.iconURL ?? "",
            humidity: Int(entity.humidity),
            pressure: entity.pressure,
            lat: entity.lat,
            lon: entity.lon,
            savedAt: entity.savedAt ?? Date()
        )
    }
}
