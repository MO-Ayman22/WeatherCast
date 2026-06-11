import Combine

protocol WeatherRepository {
    func getWeather(query: String) -> AnyPublisher<WeatherBundle, Error>
}
