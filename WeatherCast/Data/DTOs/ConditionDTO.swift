import Foundation

struct ConditionDTO: Decodable {
    let text: String
    let icon: String
    let code: Int

    var validIconURL: String {
        icon.hasPrefix("//") ? "https:\(icon)" : icon
    }
}
