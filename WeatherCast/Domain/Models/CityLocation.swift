import Foundation

struct CityLocation: Identifiable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double

    var displayName: String {
        region.isEmpty ? "\(name), \(country)" : "\(name), \(region), \(country)"
    }

    var queryString: String {
        "\(lat),\(lon)"
    }
}
