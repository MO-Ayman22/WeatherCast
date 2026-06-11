import SwiftUI

struct WeatherBackgroundView: View {

    let condition: WeatherCondition
    let isDay: Bool

    private var theme: WeatherTheme {
        WeatherTheme(date: isDay ? Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())! : Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!)
    }

    var body: some View {
        ZStack {
            gradientBackground
            animationOverlay
        }
        .ignoresSafeArea()
    }

    // MARK: - Gradient
    @ViewBuilder
    private var gradientBackground: some View {
        switch condition {
        case .sunny, .partlyCloudy:
            theme.clearSkyGradient
        case .overcast:
            theme.cloudyGradient
        case .rainy, .drizzle:
            theme.rainyGradient
        case .snowy, .blizzard, .sleet:
            theme.snowyGradient
        case .thunder:
            theme.thunderGradient
        case .fog:
            theme.fogGradient
        }
    }

    // MARK: - Animation Overlay
    @ViewBuilder
    private var animationOverlay: some View {
        switch condition {
        case .sunny:
            SunAnimationView()
        case .partlyCloudy, .overcast:
            CloudAnimationView()
        case .rainy, .drizzle:
            RainAnimationView()
        case .thunder:
            ThunderAnimationView()
        case .snowy, .blizzard, .sleet:
            SnowAnimationView()
        case .fog:
            FogAnimationView()
        }
    }
}
