import Combine

class CheckIfSavedUseCase {

    private let local: WeatherLocalDataSource

    init(local: WeatherLocalDataSource) {
        self.local = local
    }

    func execute(locationName: String) -> AnyPublisher<Bool, Error> {
        local.isLocationSaved(named: locationName)
    }
}
