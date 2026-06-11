import Combine

class SaveLocationUseCase {

    private let local: WeatherLocalDataSource

    init(local: WeatherLocalDataSource) {
        self.local = local
    }

    func execute(bundle: WeatherBundle) -> AnyPublisher<Void, Error> {
        local.saveLocation(bundle)
    }
}
