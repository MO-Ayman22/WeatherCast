import Combine

class CheckIfSavedUseCase {

    private let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func execute(locationName: String) -> AnyPublisher<Bool, Error> {
        repository.isLocationSaved(named: locationName)
    }
}
