import Combine

class RemoveLocationUseCase {

    private let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func execute(locationName: String) -> AnyPublisher<Void, Error> {
        repository.removeLocation(named: locationName)
    }
}
