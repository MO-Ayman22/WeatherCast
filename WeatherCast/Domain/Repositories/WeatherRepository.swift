import Combine

protocol WeatherRepository {
    func getWeather(query: String) -> AnyPublisher<WeatherBundle, Error>
    func saveLocation(_ bundle: WeatherBundle) -> AnyPublisher<Void, Error>
    func removeLocation(named locationName: String) -> AnyPublisher<Void, Error>
    func getSavedLocations() -> AnyPublisher<[SavedLocation], Error>
    func isLocationSaved(named locationName: String) -> AnyPublisher<Bool, Error>
    func undoLastDelete() -> AnyPublisher<Void, Error>
}
