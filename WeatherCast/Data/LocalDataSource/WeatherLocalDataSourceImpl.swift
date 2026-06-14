//
//  WeatherLocalDataSourceImpl.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import CoreData
import Combine

enum LocalDataSourceError: Error {
    case deallocated
}

class WeatherLocalDataSourceImpl: WeatherLocalDataSource {

    private let coreDataManager: CoreDataManager
    private let currentCacheThreshold: TimeInterval = 30 * 60
    private let forecastCacheThreshold: TimeInterval = 3 * 60 * 60 
    private var lastDeleteContext: NSManagedObjectContext?
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Fetch Cached Bundle

    func fetchCachedBundle(for location: String) -> AnyPublisher<WeatherBundle?, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(LocalDataSourceError.deallocated))
                return
            }
            let context = self.coreDataManager.backgroundContext

            context.perform {
                do {
                    let currentRequest = CachedCurrentWeather.fetchRequest()
                    currentRequest.predicate = NSPredicate(format: "location == %@", location)
                    currentRequest.fetchLimit = 1

                    guard let cached = try context.fetch(currentRequest).first else {
                        promise(.success(nil))
                        return
                    }

                    guard !self.isExpired(cached.cachedAt, threshold: self.currentCacheThreshold) else {
                        promise(.success(nil))
                        return
                    }

                    let dailyRequest = CachedDailyWeather.fetchRequest()
                    dailyRequest.predicate = NSPredicate(format: "locationKey == %@", location)
                    let cachedDays = try context.fetch(dailyRequest)

                    guard let firstDay = cachedDays.first,
                          !self.isExpired(firstDay.cachedAt, threshold: self.forecastCacheThreshold) else {
                        promise(.success(nil))
                        return
                    }

                    let hourlyRequest = CachedHourlyWeather.fetchRequest()
                    hourlyRequest.predicate = NSPredicate(format: "locationKey == %@", location)
                    let cachedHours = try context.fetch(hourlyRequest)

                    promise(.success(self.mapToBundle(
                        current: cached,
                        days: cachedDays,
                        hours: cachedHours
                    )))

                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Save Bundle

    func saveBundle(_ bundle: WeatherBundle) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(LocalDataSourceError.deallocated))
                return
            }
            let context = self.coreDataManager.backgroundContext

            context.perform {
                do {
                    let locationKey = bundle.current.location
                    let now = Date()

                    self.deleteExisting(
                        CachedCurrentWeather.fetchRequest(),
                        predicate: NSPredicate(format: "location == %@", locationKey),
                        context: context
                    )
                    self.deleteExisting(
                        CachedDailyWeather.fetchRequest(),
                        predicate: NSPredicate(format: "locationKey == %@", locationKey),
                        context: context
                    )
                    self.deleteExisting(
                        CachedHourlyWeather.fetchRequest(),
                        predicate: NSPredicate(format: "locationKey == %@", locationKey),
                        context: context
                    )

                    self.populateCurrent(
                        CachedCurrentWeather(context: context),
                        from: bundle.current,
                        locationKey: locationKey,
                        cachedAt: now
                    )

                    for day in bundle.forecast {
                        self.populateDay(
                            CachedDailyWeather(context: context),
                            from: day,
                            locationKey: locationKey,
                            cachedAt: now
                        )
                        for hour in day.hours {
                            self.populateHour(
                                CachedHourlyWeather(context: context),
                                from: hour,
                                dayDate: day.date,
                                locationKey: locationKey
                            )
                        }
                    }

                    try self.coreDataManager.save(context: context)
                    promise(.success(()))

                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Saved Locations

    func fetchSavedLocations() -> AnyPublisher<[SavedLocation], Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(LocalDataSourceError.deallocated))
                return
            }
            let context = self.coreDataManager.backgroundContext

            context.perform {
                let request = SavedLocationEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]

                do {
                    let results = try context.fetch(request)
                    let locations = results.map { self.mapToSavedLocation($0) }
                    promise(.success(locations))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func saveLocation(_ bundle: WeatherBundle) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(LocalDataSourceError.deallocated))
                return
            }
            let context = self.coreDataManager.backgroundContext

            context.perform {
                do {
                    let request = SavedLocationEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "location == %@", bundle.current.location)
                    let existing = try context.fetch(request)
                    existing.forEach { context.delete($0) }

                    self.populateSavedLocation(
                        SavedLocationEntity(context: context),
                        from: bundle.current
                    )

                    try self.coreDataManager.save(context: context)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func removeLocation(named location: String) -> AnyPublisher<Void, Error> {
        Future { [self] promise in
            let context = coreDataManager.backgroundContext

            context.perform {
                let request = SavedLocationEntity.fetchRequest()
                request.predicate = NSPredicate(format: "location == %@", location)

                do {
                    let results = try context.fetch(request)
                    results.forEach { context.delete($0) }

                    context.undoManager?.beginUndoGrouping()
                    try self.coreDataManager.save(context: context)
                    context.undoManager?.endUndoGrouping()

                    self.lastDeleteContext = context
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func undoLastDelete() -> AnyPublisher<Void, Error> {
        Future { [self] promise in
            guard let context = lastDeleteContext else {
                promise(.success(()))
                return
            }

            context.perform {
                context.undoManager?.undo()
                do {
                    try self.coreDataManager.save(context: context)
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
            guard let self else {
                promise(.failure(LocalDataSourceError.deallocated))
                return
            }
            let context = self.coreDataManager.backgroundContext

            context.perform {
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
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private Helpers

    private func populateCurrent(
        _ entity: CachedCurrentWeather,
        from current: CurrentWeather,
        locationKey: String,
        cachedAt: Date
    ) {
        entity.location      = locationKey
        entity.temperature   = current.temperature
        entity.feelsLike     = current.feelsLike
        entity.conditionCode = Int32(current.conditionCode)
        entity.condition     = current.condition
        entity.iconURL       = current.iconURL
        entity.humidity      = Int32(current.humidity)
        entity.pressure      = current.pressure
        entity.visibility    = current.visibility
        entity.isDay         = current.isDay
        entity.lat           = current.lat
        entity.lon           = current.lon
        entity.cachedAt      = cachedAt
    }

    private func populateDay(
        _ entity: CachedDailyWeather,
        from day: DailyWeather,
        locationKey: String,
        cachedAt: Date
    ) {
        entity.date          = day.date
        entity.dayLabel      = day.dayLabel
        entity.maxTemp       = day.maxTemp
        entity.minTemp       = day.minTemp
        entity.conditionCode = Int32(day.conditionCode)
        entity.condition     = day.condition
        entity.iconURL       = day.iconURL
        entity.locationKey   = locationKey
        entity.cachedAt      = cachedAt
    }

    private func populateHour(
        _ entity: CachedHourlyWeather,
        from hour: HourlyWeather,
        dayDate: String,
        locationKey: String
    ) {
        entity.time          = hour.time
        entity.timeLabel     = hour.timeLabel
        entity.temp          = hour.temperature
        entity.conditionCode = Int32(hour.conditionCode)
        entity.condition     = hour.condition
        entity.iconURL       = hour.iconURL
        entity.isDay         = hour.isDay
        entity.dayDate       = dayDate
        entity.locationKey   = locationKey
    }
    
    private func populateSavedLocation(
        _ entity: SavedLocationEntity,
        from current: CurrentWeather
    ) {
        entity.location      = current.location
        entity.temperature   = current.temperature
        entity.feelsLike     = current.feelsLike
        entity.conditionCode = Int32(current.conditionCode)
        entity.condition     = current.condition
        entity.iconURL       = current.iconURL
        entity.humidity      = Int32(current.humidity)
        entity.pressure      = current.pressure
        entity.lat           = current.lat
        entity.lon           = current.lon
        entity.savedAt       = Date()
    }
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
    
    private func isExpired(_ date: Date?, threshold: TimeInterval) -> Bool {
        guard let date else { return true }
        return Date().timeIntervalSince(date) > threshold
    }
}
