import Combine

class GetSavedLocationsUseCase {

    private let local: WeatherLocalDataSource

    init(local: WeatherLocalDataSource) {
        self.local = local
    }

    func execute() -> AnyPublisher<[SavedLocation], Error> {
        local.fetchSavedLocations()
    }
}
