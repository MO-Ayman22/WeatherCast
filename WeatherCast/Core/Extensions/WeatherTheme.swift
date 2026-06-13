import SwiftUI

struct WeatherTheme {
    let isDay: Bool

    init(isDay: Bool) {
        self.isDay = isDay
    }

    var primaryTextColor: Color {
        isDay ? .black : .white
    }

    var secondaryTextColor: Color {
        isDay ? Color.black.opacity(0.6) : Color.white.opacity(0.7)
    }

    var clearSkyGradient: LinearGradient {
        isDay
        ? LinearGradient(
            colors: [Color(hex: "#87CEEB"), Color(hex: "#4A90D9")],
            startPoint: .top, endPoint: .bottom)
        : LinearGradient(
            colors: [Color(hex: "#0D1B2A"), Color(hex: "#1B3A5C")],
            startPoint: .top, endPoint: .bottom)
    }

    var cloudyGradient: LinearGradient {
        isDay
        ? LinearGradient(
            colors: [Color(hex: "#B0BEC5"), Color(hex: "#78909C")],
            startPoint: .top, endPoint: .bottom)
        : LinearGradient(
            colors: [Color(hex: "#263238"), Color(hex: "#37474F")],
            startPoint: .top, endPoint: .bottom)
    }

    var rainyGradient: LinearGradient {
        isDay
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

func applyTabBarAppearance(colors: [UIColor], tint: UIColor) {
    let gradientImage = makeTabBarGradient(colors: colors)

    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundImage = gradientImage
    appearance.shadowImage = UIImage()

    appearance.stackedLayoutAppearance.selected.iconColor = tint
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: tint]
    appearance.stackedLayoutAppearance.normal.iconColor = tint.withAlphaComponent(0.4)
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: tint.withAlphaComponent(0.4)]

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
}

private func makeTabBarGradient(colors: [UIColor]) -> UIImage {
    let size = CGSize(width: UIScreen.main.bounds.width, height: 83)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { context in
        let cgContext = context.cgContext
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor } as CFArray
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: cgColors,
            locations: [0, 1]
        ) else { return }
        cgContext.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: size.width, y: 0),
            options: []
        )
    }
}
