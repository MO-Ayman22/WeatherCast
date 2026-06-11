import Foundation

class DIContainer: ObservableObject {

    // MARK: - Core
    let coreDataManager = CoreDataManager.shared
    let apiService = WeatherAPIService()
    let locationManager = LocationManager()

    // MARK: - Data Sources
    lazy var localDataSource: WeatherLocalDataSource = WeatherLocalDataSourceImpl(
        coreDataManager: coreDataManager
    )

    lazy var remoteDataSource: WeatherRemoteDataSource = WeatherRemoteDataSourceImpl(
        service: apiService
    )

    // MARK: - Repositories
    lazy var weatherRepository: WeatherRepository = WeatherRepositoryImpl(
        local: localDataSource,
        remote: remoteDataSource
    )

    lazy var searchRepository: SearchRepository = SearchRepositoryImpl(
        service: apiService
    )

    // MARK: - Use Cases
    lazy var getCurrentLocationWeatherUseCase = GetCurrentLocationWeatherUseCase(
        locationManager: locationManager,
        repository: weatherRepository
    )

    lazy var getWeatherForLocationUseCase = GetWeatherForLocationUseCase(
        repository: weatherRepository
    )

    lazy var searchCitiesUseCase = SearchCitiesUseCase(
        repository: searchRepository
    )

    lazy var saveLocationUseCase = SaveLocationUseCase(
        local: localDataSource
    )

    lazy var removeLocationUseCase = RemoveLocationUseCase(
        local: localDataSource
    )

    lazy var getSavedLocationsUseCase = GetSavedLocationsUseCase(
        local: localDataSource
    )

    lazy var checkIfSavedUseCase = CheckIfSavedUseCase(
        local: localDataSource
    )
}
