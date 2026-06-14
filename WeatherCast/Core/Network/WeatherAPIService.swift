import Foundation
import Combine

class WeatherAPIService {

    func fetch<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse else {
                    throw NetworkError.noData
                }
                
                guard (200...299).contains(http.statusCode) else {
                    throw NetworkError.serverError(http.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                if error is DecodingError {
                    return NetworkError.decodingFailed(error)
                }
                return NetworkError.unknown(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
