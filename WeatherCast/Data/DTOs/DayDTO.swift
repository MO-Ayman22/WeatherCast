import Foundation

struct DayDTO: Decodable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: ConditionDTO
}

struct AstroDTO: Decodable {
    // Keeping minimal for now; add fields if needed later
}
