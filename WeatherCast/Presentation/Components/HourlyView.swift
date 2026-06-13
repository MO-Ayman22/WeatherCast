import SwiftUI

struct HourlyView: View {

    let day: DailyWeather
    let isDay: Bool
    let onDismiss: () -> Void

    private var theme: WeatherTheme { WeatherTheme(isDay: isDay) }

    private var visibleHours: [HourlyWeather] {
        guard day.dayLabel == "Today" else { return day.hours }
        let currentHour = Calendar.current.component(.hour, from: Date())
        return day.hours.filter { hour in
            let date = Date.from(apiTimeString: hour.time) ?? Date()
            let hourInt = Calendar.current.component(.hour, from: date)
            return hourInt >= currentHour
        }
    }

    var body: some View {
        ZStack {
            WeatherBackgroundView(
                condition: WeatherCondition(code: day.conditionCode),
                isDay: isDay
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        onDismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(theme.primaryTextColor)
                    }

                    Spacer()

                    Text(day.dayLabel)
                        .font(.headline)
                        .foregroundColor(theme.primaryTextColor)

                    Spacer()

                    Text("Back").opacity(0)
                }
                .padding()

                Text("\(day.minTemp.tempString) – \(day.maxTemp.tempString)")
                    .font(.subheadline)
                    .foregroundColor(theme.secondaryTextColor)
                    .padding(.bottom, 8)

                Divider()

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(visibleHours.enumerated()), id: \.element.id) { index, hour in
                            HourlyRowView(
                                hour: hour,
                                isNow: index == 0 && day.dayLabel == "Today",
                                theme: theme
                            )
                            Divider()
                        }
                    }
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding()
                    .padding(.bottom, 20)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)

    }
}
