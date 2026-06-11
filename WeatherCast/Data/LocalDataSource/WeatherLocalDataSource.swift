//
//  WeatherLocalDataSource.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import Combine

protocol WeatherLocalDataSource {
    func fetchCachedBundle(for location: String) -> AnyPublisher<WeatherBundle?, Error>
    func saveBundle(_ bundle: WeatherBundle) -> AnyPublisher<Void, Error>
    func fetchSavedLocations() -> AnyPublisher<[SavedLocation], Error>
    func saveLocation(_ bundle: WeatherBundle) -> AnyPublisher<Void, Error>
    func removeLocation(named location: String) -> AnyPublisher<Void, Error>
    func isLocationSaved(named location: String) -> AnyPublisher<Bool, Error>
}
