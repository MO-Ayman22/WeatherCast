//
//  SearchViewModel.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import Combine

enum SearchState {
    case idle
    case loading
    case success([CityLocation])
    case error(String)
}

import Foundation
import Combine

final class SearchViewModel: ObservableObject {

    @Published var searchText: String = ""
    @Published var state: SearchState = .idle

    private let searchCitiesUseCase: SearchCitiesUseCase
    private var cancellables = Set<AnyCancellable>()

    init(container: DIContainer) {
        self.searchCitiesUseCase = container.searchCitiesUseCase

        observeSearchText()
    }

    private func observeSearchText() {

        $searchText
            .debounce(for: .milliseconds(500),
                      scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.search(query: query)
            }
            .store(in: &cancellables)
    }

    private func search(query: String) {

        let query = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            state = .idle
            return
        }

        state = .loading

        searchCitiesUseCase
            .execute(query: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in

                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }

            } receiveValue: { [weak self] cities in

                self?.state = .success(cities)

            }
            .store(in: &cancellables)
    }

    func clearSearch() {
        searchText = ""
        state = .idle
    }
}
