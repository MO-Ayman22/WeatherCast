//
//  SavedLocationsViewModel.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import Combine

final class SavedLocationsViewModel: ObservableObject {

    @Published private(set) var savedLocations: [SavedLocation] = []
    @Published private(set) var isLoading: Bool = false

    private let getSavedLocationsUseCase: GetSavedLocationsUseCase
    private let removeLocationUseCase: RemoveLocationUseCase
    private var cancellables = Set<AnyCancellable>()

    init(
        getSavedLocationsUseCase: GetSavedLocationsUseCase,
        removeLocationUseCase: RemoveLocationUseCase
    ) {
        self.getSavedLocationsUseCase = getSavedLocationsUseCase
        self.removeLocationUseCase = removeLocationUseCase
    }

    func loadSavedLocations() {
        isLoading = true

        getSavedLocationsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] locations in
                self?.isLoading = false
                self?.savedLocations = locations
            }
            .store(in: &cancellables)
    }

    func removeLocation(at offsets: IndexSet) {
        offsets.forEach { index in
            let location = savedLocations[index]
            removeLocationUseCase.execute(locationName: location.location)
                .receive(on: DispatchQueue.main)
                .sink { _ in } receiveValue: { [weak self] _ in
                    self?.savedLocations.remove(at: index)
                }
                .store(in: &cancellables)
        }
    }
}
