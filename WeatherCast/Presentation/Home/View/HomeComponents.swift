import SwiftUI

// MARK: - Glass Card
struct GlassCardView<Content: View>: View {

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
    }
}

// MARK: - Weather Icon
struct WeatherIconView: View {

    let urlString: String
    let size: CGFloat

    init(urlString: String, size: CGFloat = 64) {
        self.urlString = urlString
        self.size = size
    }

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            case .failure:
                Image(systemName: "cloud.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundColor(.white)
            case .empty:
                ProgressView()
                    .frame(width: size, height: size)
            @unknown default:
                EmptyView()
            }
        }
    }
}

// MARK: - Top Section
struct TopSectionView: View {

    let bundle: WeatherBundle
    let theme: WeatherTheme

    var body: some View {
        VStack(spacing: 8) {
            // Location
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.subheadline)
                Text(bundle.current.location)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .foregroundColor(theme.primaryTextColor)

            // Weather Icon
            WeatherIconView(urlString: bundle.current.iconURL, size: 80)

            // Temperature
            Text(bundle.current.temperature.tempString)
                .font(.system(size: 72, weight: .thin))
                .foregroundColor(theme.primaryTextColor)

            // Condition
            Text(bundle.current.condition)
                .font(.title3)
                .foregroundColor(theme.secondaryTextColor)

            // Min / Max
            HStack(spacing: 16) {
                Label(bundle.forecast.first?.maxTemp.tempString ?? "--", systemImage: "arrow.up")
                Label(bundle.forecast.first?.minTemp.tempString ?? "--", systemImage: "arrow.down")
            }
            .font(.subheadline)
            .foregroundColor(theme.secondaryTextColor)
        }
        .padding(.top, 20)
    }
}

// MARK: - Forecast Row
struct ForecastRowView: View {

    let day: DailyWeather
    let theme: WeatherTheme

    var body: some View {
        HStack {
            Text(day.dayLabel)
                .frame(width: 90, alignment: .leading)
                .font(.subheadline)
                .foregroundColor(theme.primaryTextColor)

            Spacer()

            WeatherIconView(urlString: day.iconURL, size: 28)

            Spacer()

            HStack(spacing: 8) {
                Label(day.maxTemp.tempString, systemImage: "arrow.up")
                Label(day.minTemp.tempString, systemImage: "arrow.down")
            }
            .font(.subheadline)
            .foregroundColor(theme.secondaryTextColor)
        }
        .padding(.vertical, 4)
    }
}


struct ForecastSectionView: View {

    let bundle: WeatherBundle
    let theme: WeatherTheme
    let onDaySelected: (DailyWeather) -> Void

    var body: some View {
        GlassCardView {
            VStack(alignment: .leading, spacing: 12) {

                Label("3-DAY FORECAST", systemImage: "calendar")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.secondaryTextColor)

                Divider()

                ForEach(bundle.forecast) { day in
                    Button {
                        onDaySelected(day)
                    } label: {
                        ForecastRowView(day: day, theme: theme)
                    }

                    if day.id != bundle.forecast.last?.id {
                        Divider()
                    }
                }
            }
        }
    }
}
// MARK: - Stat Tile
struct StatTileView: View {

    let icon: String
    let value: String
    let label: String
    let theme: WeatherTheme

    var body: some View {
        GlassCardView {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(theme.primaryTextColor)
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.primaryTextColor)
                Text(label)
                    .font(.caption)
                    .foregroundColor(theme.secondaryTextColor)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Stats Section
struct StatsSectionView: View {

    let current: CurrentWeather
    let theme: WeatherTheme

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatTileView(
                icon: "eye.fill",
                value: current.visibility.visibilityString,
                label: "Visibility",
                theme: theme
            )
            StatTileView(
                icon: "humidity.fill",
                value: "\(current.humidity)%",
                label: "Humidity",
                theme: theme
            )
            StatTileView(
                icon: "thermometer.medium",
                value: current.feelsLike.tempString,
                label: "Feels Like",
                theme: theme
            )
            StatTileView(
                icon: "gauge.medium",
                value: current.pressure.pressureString,
                label: "Pressure",
                theme: theme
            )
        }
    }
}


// MARK: - Rain Animation
struct Raindrop {
    var x: CGFloat
    var startY: CGFloat
    var speed: CGFloat
    var opacity: CGFloat
    var length: CGFloat

    static func generate(count: Int) -> [Raindrop] {
        (0..<count).map { _ in
            Raindrop(
                x: CGFloat.random(in: 0...1),
                startY: CGFloat.random(in: 0...1),
                speed: CGFloat.random(in: 200...400),
                opacity: CGFloat.random(in: 0.3...0.7),
                length: CGFloat.random(in: 15...25)
            )
        }
    }
}

struct RainAnimationView: View {
    let drops: [Raindrop] = Raindrop.generate(count: 80)

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for drop in drops {
                    let x = drop.x * size.width
                    let rawY = drop.startY * size.height + CGFloat(now) * drop.speed
                    let y = rawY.truncatingRemainder(dividingBy: size.height)
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x - 4, y: y + drop.length))
                    context.stroke(path, with: .color(.white.opacity(drop.opacity)), lineWidth: 1.5)
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Snow Animation
struct Snowflake {
    var x: CGFloat
    var startY: CGFloat
    var size: CGFloat
    var speed: CGFloat
    var phaseOffset: CGFloat

    static func generate(count: Int) -> [Snowflake] {
        (0..<count).map { _ in
            Snowflake(
                x: CGFloat.random(in: 0...1),
                startY: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 3...8),
                speed: CGFloat.random(in: 40...80),
                phaseOffset: CGFloat.random(in: 0...(.pi * 2))
            )
        }
    }
}

struct SnowAnimationView: View {
    let flakes: [Snowflake] = Snowflake.generate(count: 60)

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for flake in flakes {
                    let drift = sin(CGFloat(now) * 0.5 + flake.phaseOffset) * 20
                    let x = flake.x * size.width + drift
                    let rawY = flake.startY * size.height + CGFloat(now) * flake.speed
                    let y = rawY.truncatingRemainder(dividingBy: size.height)
                    let rect = CGRect(x: x - flake.size/2, y: y - flake.size/2,
                                     width: flake.size, height: flake.size)
                    context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.8)))
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Sun Animation (FIXED)
// Root cause was: .animation(value:) was declared AFTER onAppear changed the value.
// Fix: use withAnimation inside onAppear instead of the declarative modifier.
struct SunAnimationView: View {

    @State private var rotation: Double = 0
    @State private var glowScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.15

    var body: some View {
        ZStack {
            // Outer glow — driven by glowOpacity state
            Circle()
                .fill(Color.yellow.opacity(glowOpacity))
                .frame(width: 250, height: 250)
                .scaleEffect(glowScale)

            // Rays — driven by rotation state
            ForEach(0..<8, id: \.self) { i in
                Rectangle()
                    .fill(Color.yellow.opacity(0.4))
                    .frame(width: 3, height: 60)
                    .offset(y: -90)
                    .rotationEffect(.degrees(Double(i) * 45 + rotation))
            }

            // Sun core
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#FFD700"), Color(hex: "#FF6B35")],
                        center: .center,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(width: 100, height: 100)
        }
        .onAppear {
            // Rays: continuous rotation
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            // Glow: pulse in/out
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowScale = 1.2
                glowOpacity = 0.3
            }
        }
    }
}

// MARK: - Cloud Animation
struct CloudLayer: Identifiable {
    let id = UUID()
    var speed: CGFloat
    var opacity: CGFloat
    var scale: CGFloat
    var yOffset: CGFloat
}

struct CloudAnimationView: View {
    let layers: [CloudLayer] = [
        CloudLayer(speed: 30, opacity: 0.9, scale: 1.2, yOffset: 80),
        CloudLayer(speed: 20, opacity: 0.6, scale: 1.0, yOffset: 160),
        CloudLayer(speed: 10, opacity: 0.3, scale: 0.8, yOffset: 240)
    ]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for layer in layers {
                    let rawX = CGFloat(now) * layer.speed
                    let x = rawX.truncatingRemainder(dividingBy: size.width + 200) - 200
                    var ctx = context
                    ctx.opacity = layer.opacity
                    ctx.translateBy(x: x, y: layer.yOffset)
                    ctx.scaleBy(x: layer.scale, y: layer.scale)
                    var path = Path()
                    path.addEllipse(in: CGRect(x: 0,  y: 0,   width: 120, height: 60))
                    path.addEllipse(in: CGRect(x: 30, y: -30, width: 80,  height: 60))
                    path.addEllipse(in: CGRect(x: 70, y: -10, width: 90,  height: 55))
                    ctx.fill(path, with: .color(.white))
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Thunder Animation
struct ThunderAnimationView: View {
    @State private var flashOpacity: CGFloat = 0

    var body: some View {
        ZStack {
            RainAnimationView()

            Color.white
                .opacity(flashOpacity)
                .ignoresSafeArea()
        }
        .onAppear {
            triggerLightning()
        }
    }

    private func triggerLightning() {
        let delay = Double.random(in: 3...8)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeIn(duration: 0.05)) { flashOpacity = 0.7 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.15)) { flashOpacity = 0 }
                triggerLightning()
            }
        }
    }
}

// MARK: - Fog Animation (FIXED: was nested inside ThunderAnimationView — now top-level)
struct FogAnimationView: View {
    @State private var offset1: CGFloat = -30
    @State private var offset2: CGFloat = 30

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.white.opacity(0.2))
                .frame(width: 400, height: 150)
                .blur(radius: 40)
                .offset(x: offset1, y: -50)

            Ellipse()
                .fill(Color.white.opacity(0.15))
                .frame(width: 350, height: 120)
                .blur(radius: 35)
                .offset(x: offset2, y: 50)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                offset1 = 30
            }
            withAnimation(.easeInOut(duration: 14).repeatForever(autoreverses: true)) {
                offset2 = -30
            }
        }
    }
}
