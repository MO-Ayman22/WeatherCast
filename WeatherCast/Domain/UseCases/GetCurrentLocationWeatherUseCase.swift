import Combine
import Foundation

class GetCurrentLocationWeatherUseCase {

    private let locationManager: LocationManager
    private let repository: WeatherRepository

    init(locationManager: LocationManager, repository: WeatherRepository) {
        self.locationManager = locationManager
        self.repository = repository
    }

    func execute() -> AnyPublisher<WeatherBundle, Error> {
        locationManager.requestLocation()
        
        return locationManager.coordinatePublisher
            .first()
            .flatMap { [weak self] coordinate -> AnyPublisher<WeatherBundle, Error> in
                guard let self else {
                    return Fail(error: NSError()).eraseToAnyPublisher()
                }
                let query = "\(coordinate.latitude),\(coordinate.longitude)"
                return self.repository.getWeather(query: query)
            }
            .eraseToAnyPublisher()
    }
}
