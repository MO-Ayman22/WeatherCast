//
//  WeatherDetailsViewModel.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import Combine

enum WeatherDetailsState: Equatable {
    case idle
    case loading
    case success(WeatherBundle)
    case error(String)

    static func == (lhs: WeatherDetailsState, rhs: WeatherDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading): return true
        case (.error(let a), .error(let b)): return a == b
        case (.success(let a), .success(let b)): return a.current.location == b.current.location
        default: return false
        }
    }
}

final class WeatherDetailsViewModel: ObservableObject {

    @Published private(set) var state: WeatherDetailsState = .idle
    @Published private(set) var isSaved: Bool = false
    @Published var showRemoveAlert: Bool = false

    private let city: CityLocation
    private let getWeatherForLocationUseCase: GetWeatherForLocationUseCase
    private let saveLocationUseCase: SaveLocationUseCase
    private let removeLocationUseCase: RemoveLocationUseCase
    private let checkIfSavedUseCase: CheckIfSavedUseCase
    private var cancellables = Set<AnyCancellable>()

    init(city: CityLocation, container: DIContainer) {
        self.city = city
        self.getWeatherForLocationUseCase = container.getWeatherForLocationUseCase
        self.saveLocationUseCase = container.saveLocationUseCase
        self.removeLocationUseCase = container.removeLocationUseCase
        self.checkIfSavedUseCase = container.checkIfSavedUseCase
    }

    func loadWeather() {
        guard state != .loading else { return }
        state = .loading

        getWeatherForLocationUseCase.execute(query: city.queryString)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] bundle in
                guard let self else { return }
                self.state = .success(bundle)
                self.checkIfSaved(locationName: bundle.current.location)
            }
            .store(in: &cancellables)
    }

    func toggleSave() {
        guard case .success(let bundle) = state else { return }

        if isSaved {
            showRemoveAlert = true
        } else {
            saveLocationUseCase.execute(bundle: bundle)
                .receive(on: DispatchQueue.main)
                .sink { _ in } receiveValue: { [weak self] _ in
                    self?.isSaved = true
                    ToastManager.shared.show(
                        message: "Added to saved locations",
                        type: .favorite,
                        isTabBarHidden: true
                    )
                }
                .store(in: &cancellables)
        }
    }
    
    func confirmRemove() {
        guard case .success(let bundle) = state else { return }
        removeLocationUseCase.execute(locationName: bundle.current.location)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] _ in
                self?.isSaved = false
                ToastManager.shared.show(
                    message: "Removed from saved locations",
                    type: .info,
                    isTabBarHidden: true
                )
            }
            .store(in: &cancellables)
    }
    
    private func checkIfSaved(locationName: String) {
        checkIfSavedUseCase.execute(locationName: locationName)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] saved in
                self?.isSaved = saved
            }
            .store(in: &cancellables)
    }
}
