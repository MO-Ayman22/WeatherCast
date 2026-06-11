import Foundation

struct WeatherResponseDTO: Decodable {
    let location: LocationDTO
    let current: CurrentDTO
    let forecast: ForecastDTO
}
