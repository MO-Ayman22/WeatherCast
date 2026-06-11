//
//  WeatherRemoteDataSource.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import Combine

protocol WeatherRemoteDataSource {
    func fetchForecast(query: String) -> AnyPublisher<WeatherResponseDTO, NetworkError>
    func searchCities(query: String) -> AnyPublisher<[SearchResultDTO], NetworkError>
}
