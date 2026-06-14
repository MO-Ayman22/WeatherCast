import Combine

class GetSavedLocationsUseCase {

    private let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[SavedLocation], Error> {
        repository.getSavedLocations()
    }
}
