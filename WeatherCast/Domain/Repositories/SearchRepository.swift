import Combine

protocol SearchRepository {
    func searchCities(query: String) -> AnyPublisher<[CityLocation], Error>
}
