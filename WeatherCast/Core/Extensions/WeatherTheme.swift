import SwiftUI

struct WeatherTheme {
    let isMorning: Bool

    init(date: Date = Date()) {
        self.isMorning = date.isMorning
    }

    var primaryTextColor: Color {
        isMorning ? .black : .white
    }

    var secondaryTextColor: Color {
        isMorning ? Color.black.opacity(0.6) : Color.white.opacity(0.7)
    }

    var clearSkyGradient: LinearGradient {
        isMorning
        ? LinearGradient(
            colors: [Color(hex: "#87CEEB"), Color(hex: "#4A90D9")],
            startPoint: .top, endPoint: .bottom)
        : LinearGradient(
            colors: [Color(hex: "#0D1B2A"), Color(hex: "#1B3A5C")],
            startPoint: .top, endPoint: .bottom)
    }

    var cloudyGradient: LinearGradient {
        isMorning
        ? LinearGradient(
            colors: [Color(hex: "#B0BEC5"), Color(hex: "#78909C")],
            startPoint: .top, endPoint: .bottom)
        : LinearGradient(
            colors: [Color(hex: "#263238"), Color(hex: "#37474F")],
            startPoint: .top, endPoint: .bottom)
    }

    var rainyGradient: LinearGradient {
        isMorning
        ? LinearGradient(
            colors: [Color(hex: "#546E7A"), Color(hex: "#37474F")],
            startPoint: .top, endPoint: .bottom)
        : LinearGradient(
            colors: [Color(hex: "#1C2833"), Color(hex: "#2C3E50")],
            startPoint: .top, endPoint: .bottom)
    }

    var snowyGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: "#E3F2FD"), Color(hex: "#B0C4DE")],
            startPoint: .top, endPoint: .bottom)
    }

    var thunderGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: "#1A1A2E"), Color(hex: "#4A235A")],
            startPoint: .top, endPoint: .bottom)
    }

    var fogGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: "#CFD8DC"), Color(hex: "#B0BEC5")],
            startPoint: .top, endPoint: .bottom)
    }
}
