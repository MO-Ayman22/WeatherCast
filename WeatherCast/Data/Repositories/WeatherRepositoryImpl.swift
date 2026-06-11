//
//  WeatherRepositoryImpl.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import Combine

class WeatherRepositoryImpl: WeatherRepository {

    private let local: WeatherLocalDataSource
    private let remote: WeatherRemoteDataSource

    init(local: WeatherLocalDataSource, remote: WeatherRemoteDataSource) {
        self.local = local
        self.remote = remote
    }

    func getWeather(query: String) -> AnyPublisher<WeatherBundle, Error> {
        local.fetchCachedBundle(for: query)
            .flatMap { [weak self] cached -> AnyPublisher<WeatherBundle, Error> in
                guard let self else {
                    return Fail(error: NSError()).eraseToAnyPublisher()
                }
                if let bundle = cached {
                    return Just(bundle)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.fetchFromRemote(query: query)
            }
            .eraseToAnyPublisher()
    }

    private func fetchFromRemote(query: String) -> AnyPublisher<WeatherBundle, Error> {
        remote.fetchForecast(query: query)
            .mapError { $0 as Error }
            .map { dto -> WeatherBundle in
                self.mapToBundle(dto: dto)
            }
            .flatMap { [weak self] bundle -> AnyPublisher<WeatherBundle, Error> in
                guard let self else {
                    return Fail(error: NSError()).eraseToAnyPublisher()
                }
                return self.local.saveBundle(bundle)
                    .map { bundle }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // MARK: - DTO → Domain Mapping

    private func mapToBundle(dto: WeatherResponseDTO) -> WeatherBundle {
        let current = CurrentWeather(
            location: dto.location.name,
            temperature: dto.current.temp_c,
            feelsLike: dto.current.feelslike_c,
            conditionCode: dto.current.condition.code,
            condition: dto.current.condition.text,
            iconURL: dto.current.condition.validIconURL,
            humidity: dto.current.humidity,
            pressure: dto.current.pressure_mb,
            visibility: dto.current.vis_km,
            isDay: dto.current.is_day == 1,
            lat: dto.location.lat,
            lon: dto.location.lon
        )

        let forecast = dto.forecast.forecastday.enumerated().map { index, dayDTO in
            mapToDaily(dayDTO: dayDTO, index: index)
        }

        return WeatherBundle(
            current: current,
            forecast: forecast,
            isDay: dto.current.is_day == 1
        )
    }

    private func mapToDaily(dayDTO: ForecastDayDTO, index: Int) -> DailyWeather {
        let date = Date.from(apiDateString: dayDTO.date) ?? Date()
        let dayLabel = date.dayLabel()

        let hours = dayDTO.hour.map { hourDTO in
            mapToHourly(hourDTO: hourDTO)
        }

        return DailyWeather(
            date: dayDTO.date,
            dayLabel: dayLabel,
            maxTemp: dayDTO.day.maxtemp_c,
            minTemp: dayDTO.day.mintemp_c,
            conditionCode: dayDTO.day.condition.code,
            condition: dayDTO.day.condition.text,
            iconURL: dayDTO.day.condition.validIconURL,
            hours: hours
        )
    }

    private func mapToHourly(hourDTO: HourDTO) -> HourlyWeather {
        let date = Date.from(apiTimeString: hourDTO.time) ?? Date()
        let timeLabel = date.hourLabel()

        return HourlyWeather(
            time: hourDTO.time,
            timeLabel: timeLabel,
            temperature: hourDTO.temp_c,
            conditionCode: hourDTO.condition.code,
            condition: hourDTO.condition.text,
            iconURL: hourDTO.condition.validIconURL,
            isDay: hourDTO.is_day == 1
        )
    }
}
