//
//  SearchRepositoryImpl.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import Combine

class SearchRepositoryImpl: SearchRepository {

    private let service: WeatherAPIService

    init(service: WeatherAPIService) {
        self.service = service
    }

    func searchCities(query: String) -> AnyPublisher<[CityLocation], Error> {
        service.fetch(endpoint: .search(query: query))
            .mapError { $0 as Error }
            .map { (dtos: [SearchResultDTO]) in
                dtos.map { dto in
                    CityLocation(
                        id: dto.id,
                        name: dto.name,
                        region: dto.region,
                        country: dto.country,
                        lat: dto.lat,
                        lon: dto.lon
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
