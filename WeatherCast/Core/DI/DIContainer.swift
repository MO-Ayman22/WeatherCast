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
        repository: weatherRepository
    )

    lazy var removeLocationUseCase = RemoveLocationUseCase(
        repository: weatherRepository
    )

    lazy var getSavedLocationsUseCase = GetSavedLocationsUseCase(
        repository: weatherRepository
    )

    lazy var checkIfSavedUseCase = CheckIfSavedUseCase(
        repository: weatherRepository
    )
    
    lazy var undoLastDeleteUseCase = UndoLastDeleteUseCase(
        repository: weatherRepository
    )
    
    func makeWeatherDetailsViewModel(
        city: CityLocation
    ) -> WeatherDetailsViewModel {
        WeatherDetailsViewModel(
            city: city,
            getWeatherForLocationUseCase: getWeatherForLocationUseCase,
            saveLocationUseCase: saveLocationUseCase,
            removeLocationUseCase: removeLocationUseCase,
            checkIfSavedUseCase: checkIfSavedUseCase,
            undoLastDeleteUseCase: undoLastDeleteUseCase
        )
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(
            searchCitiesUseCase: searchCitiesUseCase
        )
    }
    
    func makeSavedLocationsViewModel() -> SavedLocationsViewModel {
        SavedLocationsViewModel(
            getSavedLocationsUseCase : getSavedLocationsUseCase,
            removeLocationUseCase : removeLocationUseCase
        )
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            getCurrentLocationWeatherUseCase: getCurrentLocationWeatherUseCase,
            saveLocationUseCase: saveLocationUseCase,
            removeLocationUseCase: removeLocationUseCase,
            checkIfSavedUseCase: checkIfSavedUseCase
        )
    }
}
