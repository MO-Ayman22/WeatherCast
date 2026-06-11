import Combine

class SearchCitiesUseCase {

    private let repository: SearchRepository

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func execute(query: String) -> AnyPublisher<[CityLocation], Error> {
        repository.searchCities(query: query)
    }
}
