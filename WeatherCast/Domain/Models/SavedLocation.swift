import Foundation

struct SavedLocation: Identifiable, Codable {
    let id: UUID
    let location: String
    let temperature: Double
    let feelsLike: Double
    let conditionCode: Int
    let condition: String
    let iconURL: String
    let humidity: Int
    let pressure: Double
    let lat: Double
    let lon: Double
    let savedAt: Date

    init(
        id: UUID = UUID(),
        location: String,
        temperature: Double,
        feelsLike: Double,
        conditionCode: Int,
        condition: String,
        iconURL: String,
        humidity: Int,
        pressure: Double,
        lat: Double,
        lon: Double,
        savedAt: Date = Date()
    ) {
        self.id = id
        self.location = location
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.conditionCode = conditionCode
        self.condition = condition
        self.iconURL = iconURL
        self.humidity = humidity
        self.pressure = pressure
        self.lat = lat
        self.lon = lon
        self.savedAt = savedAt
    }

    var weatherCondition: WeatherCondition {
        WeatherCondition(code: conditionCode)
    }

    var queryString: String {
        "\(lat),\(lon)"
    }
}
