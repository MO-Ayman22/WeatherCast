import Foundation

struct CurrentWeather {
    let location: String
    let temperature: Double
    let feelsLike: Double
    let conditionCode: Int
    let condition: String
    let iconURL: String
    let humidity: Int
    let pressure: Double
    let visibility: Double
    let isDay: Bool
    let lat: Double
    let lon: Double

    var weatherCondition: WeatherCondition {
        WeatherCondition(code: conditionCode)
    }
}
