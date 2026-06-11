import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case serverError(Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "No data received."
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
