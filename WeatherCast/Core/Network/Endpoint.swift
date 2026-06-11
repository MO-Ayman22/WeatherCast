import Foundation

enum Endpoint {
    case forecast(query: String, days: Int)
    case search(query: String)

    private var baseURL: String { "https://api.weatherapi.com/v1" }
    private var apiKey: String { "9406cf6987a74473ab5193840261006" }

    var url: URL? {
        switch self {
        case .forecast(let query, let days):
            let string = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(query)&days=\(days)&aqi=no&alerts=no"
            return URL(string: string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string)

        case .search(let query):
            let string = "\(baseURL)/search.json?key=\(apiKey)&q=\(query)"
            return URL(string: string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string)
        }
    }
}
