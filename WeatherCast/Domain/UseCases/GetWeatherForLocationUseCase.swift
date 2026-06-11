import Combine

class GetWeatherForLocationUseCase {

    private let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func execute(query: String) -> AnyPublisher<WeatherBundle, Error> {
        repository.getWeather(query: query)
    }
}
