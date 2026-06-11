import Foundation

struct LocationDTO: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let localtime: String
}
