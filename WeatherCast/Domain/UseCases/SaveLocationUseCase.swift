import Combine

class SaveLocationUseCase {

    private let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func execute(bundle: WeatherBundle) -> AnyPublisher<Void, Error> {
        repository.saveLocation(bundle)
    }
}
