//
//  StatsSectionView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct StatsSectionView: View {

    let current: CurrentWeather
    let theme: WeatherTheme

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
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
