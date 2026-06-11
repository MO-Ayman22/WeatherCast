import Foundation

struct HourlyWeather: Identifiable {
    let id = UUID()
    let time: String        // "2025-06-03 14:00"
    let timeLabel: String   // "2 PM" or "Now"
    let temperature: Double
    let conditionCode: Int
    let condition: String
    let iconURL: String
    let isDay: Bool

    var weatherCondition: WeatherCondition {
        WeatherCondition(code: conditionCode)
    }
}
