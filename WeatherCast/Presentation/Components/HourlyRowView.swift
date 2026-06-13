import SwiftUI

struct HourlyRowView: View {

    let hour: HourlyWeather
    let isNow: Bool
    let theme: WeatherTheme

    var body: some View {
        HStack {
            Text(isNow ? "Now" : hour.timeLabel)
                .frame(width: 70, alignment: .leading)
                .font(.subheadline)
                .fontWeight(isNow ? .bold : .regular)
                .foregroundColor(theme.primaryTextColor)

            Spacer()

            WeatherIconView(urlString: hour.iconURL, size: 32)

            Spacer()

            Text(hour.temperature.tempString)
                .font(.subheadline)
                .fontWeight(isNow ? .bold : .regular)
                .foregroundColor(theme.primaryTextColor)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(isNow ? Color.white.opacity(0.15) : Color.clear)
    }
}
