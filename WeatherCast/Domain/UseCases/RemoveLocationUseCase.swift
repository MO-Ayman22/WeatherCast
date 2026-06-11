import Combine

class RemoveLocationUseCase {

    private let local: WeatherLocalDataSource

    init(local: WeatherLocalDataSource) {
        self.local = local
    }

    func execute(locationName: String) -> AnyPublisher<Void, Error> {
        local.removeLocation(named: locationName)
    }
}
