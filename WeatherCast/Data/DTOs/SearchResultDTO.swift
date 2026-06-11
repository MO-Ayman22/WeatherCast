import Foundation

struct SearchResultDTO: Decodable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
}
