import Foundation

struct HourDTO: Decodable {
    let time: String
    let temp_c: Double
    let is_day: Int
    let condition: ConditionDTO
}
