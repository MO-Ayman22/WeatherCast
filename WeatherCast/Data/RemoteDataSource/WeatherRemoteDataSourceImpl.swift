//
//  WeatherRemoteDataSourceImpl.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import Combine

class WeatherRemoteDataSourceImpl: WeatherRemoteDataSource {

    private let service: WeatherAPIService

    init(service: WeatherAPIService) {
        self.service = service
    }

    func fetchForecast(query: String) -> AnyPublisher<WeatherResponseDTO, NetworkError> {
        service.fetch(endpoint: .forecast(query: query, days: 3))
    }

    func searchCities(query: String) -> AnyPublisher<[SearchResultDTO], NetworkError> {
        service.fetch(endpoint: .search(query: query))
    }
}
