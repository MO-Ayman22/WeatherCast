import Foundation

struct CurrentDTO: Decodable {
    let temp_c: Double
    let is_day: Int
    let condition: ConditionDTO
    let humidity: Int
    let feelslike_c: Double
    let vis_km: Double
    let pressure_mb: Double
}
