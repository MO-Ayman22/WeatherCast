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
    private let undoLastDeleteUseCase: UndoLastDeleteUseCase
    private var cancellables = Set<AnyCancellable>()

    init(
        city: CityLocation,
        getWeatherForLocationUseCase: GetWeatherForLocationUseCase,
        saveLocationUseCase: SaveLocationUseCase,
        removeLocationUseCase: RemoveLocationUseCase,
        checkIfSavedUseCase: CheckIfSavedUseCase,
        undoLastDeleteUseCase: UndoLastDeleteUseCase
    ) {
        self.city = city
        self.getWeatherForLocationUseCase = getWeatherForLocationUseCase
        self.saveLocationUseCase = saveLocationUseCase
        self.removeLocationUseCase = removeLocationUseCase
        self.checkIfSavedUseCase = checkIfSavedUseCase
        self.undoLastDeleteUseCase = undoLastDeleteUseCase
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

        removeLocationUseCase.execute(
            locationName: bundle.current.location
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                print(error.localizedDescription)
                self?.showRemoveAlert = false
            }
        } receiveValue: { [weak self] _ in
            guard let self else { return }

            self.isSaved = false
            self.showRemoveAlert = false

            ToastManager.shared.showWithUndo(
                message: "Removed from saved locations"
            ) { [weak self] in
                self?.undoDelete()
            }
        }
        .store(in: &cancellables)
    }

    private func undoDelete() {
        print("Button tapped, undoing delete...")
        undoLastDeleteUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] _ in
                self?.isSaved = true
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
