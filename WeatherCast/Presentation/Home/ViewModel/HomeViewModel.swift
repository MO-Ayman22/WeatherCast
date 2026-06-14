import Foundation
import UIKit
import Combine
import SwiftUI

enum WeatherState: Equatable {
    case idle
    case loading
    case success(WeatherBundle)
    case error(String)

    static func == (lhs: WeatherState, rhs: WeatherState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading): return true
        case (.error(let a), .error(let b)): return a == b
        case (.success(let a), .success(let b)): return a.current.location == b.current.location
        default: return false
        }
    }
}

final class HomeViewModel: ObservableObject {

    @Published private(set) var state: WeatherState = .idle
    @Published private(set) var isSaved: Bool = false

    private let getCurrentLocationWeatherUseCase: GetCurrentLocationWeatherUseCase
    private let saveLocationUseCase: SaveLocationUseCase
    private let removeLocationUseCase: RemoveLocationUseCase
    private let checkIfSavedUseCase: CheckIfSavedUseCase
    private var cancellables = Set<AnyCancellable>()

    init(
        getCurrentLocationWeatherUseCase: GetCurrentLocationWeatherUseCase,
        saveLocationUseCase: SaveLocationUseCase,
        removeLocationUseCase: RemoveLocationUseCase,
        checkIfSavedUseCase: CheckIfSavedUseCase
    ) {
        self.getCurrentLocationWeatherUseCase = getCurrentLocationWeatherUseCase
        self.saveLocationUseCase = saveLocationUseCase
        self.removeLocationUseCase = removeLocationUseCase
        self.checkIfSavedUseCase = checkIfSavedUseCase
    }

    func loadWeather() {
        guard state != .loading else { return }
        state = .loading

        getCurrentLocationWeatherUseCase.execute()
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
            removeLocationUseCase.execute(locationName: bundle.current.location)
                .receive(on: DispatchQueue.main)
                .sink { _ in } receiveValue: { [weak self] _ in
                    self?.isSaved = false
                }
                .store(in: &cancellables)
        } else {
            saveLocationUseCase.execute(bundle: bundle)
                .receive(on: DispatchQueue.main)
                .sink { _ in } receiveValue: { [weak self] _ in
                    self?.isSaved = true
                }
                .store(in: &cancellables)
        }
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
