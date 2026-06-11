import Foundation

struct WeatherBundle {
    let current: CurrentWeather
    let forecast: [DailyWeather]
    let isDay: Bool

    var todayForecast: DailyWeather? { forecast.first }
}
