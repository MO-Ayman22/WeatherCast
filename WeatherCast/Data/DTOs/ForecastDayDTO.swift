import Foundation

struct ForecastDayDTO: Decodable {
    let date: String
    let day: DayDTO
    let astro: AstroDTO
    let hour: [HourDTO]
}

struct ForecastDTO: Decodable {
    let forecastday: [ForecastDayDTO]
}
