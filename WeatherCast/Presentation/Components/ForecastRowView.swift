//
//  ForecastRowView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

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
