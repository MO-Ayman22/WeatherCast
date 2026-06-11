import Foundation

struct DailyWeather: Identifiable, Hashable {
    let id = UUID()
    let date: String
    let dayLabel: String
    let maxTemp: Double
    let minTemp: Double
    let conditionCode: Int
    let condition: String
    let iconURL: String
    let hours: [HourlyWeather]

    var weatherCondition: WeatherCondition {
        WeatherCondition(code: conditionCode)
    }

    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: DailyWeather, rhs: DailyWeather) -> Bool {
        lhs.id == rhs.id
    }
}
