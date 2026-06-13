//
//  ForecastSectionView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct ForecastSectionView: View {

    let bundle: WeatherBundle
    let theme: WeatherTheme
    let onDaySelected: (DailyWeather) -> Void

    var body: some View {
        GlassCardView {
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader

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

    private var sectionHeader: some View {
        Label("3-DAY FORECAST", systemImage: "calendar")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(theme.secondaryTextColor)
    }
}
