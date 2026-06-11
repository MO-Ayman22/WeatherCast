import Foundation

extension Double {
    var tempString: String {
        "\(Int(self.rounded()))°"
    }

    var roundedString: String {
        String(format: "%.1f", self)
    }

    var visibilityString: String {
        "\(roundedString) km"
    }

    var pressureString: String {
        "\(Int(self.rounded())) mb"
    }
}
