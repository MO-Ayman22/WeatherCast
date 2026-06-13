//
//  TopSectionView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct TopSectionView: View {

    let bundle: WeatherBundle
    let theme: WeatherTheme

    var body: some View {
        VStack(spacing: 8) {
            locationView
            WeatherIconView(urlString: bundle.current.iconURL, size: 80)
            temperatureView
            conditionView
            minMaxView
        }
        .padding(.top, 20)
    }

    private var locationView: some View {
        HStack(spacing: 4) {
            Image(systemName: "location.fill")
                .font(.subheadline)
            Text(bundle.current.location)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .foregroundColor(theme.primaryTextColor)
    }

    private var temperatureView: some View {
        Text(bundle.current.temperature.tempString)
            .font(.system(size: 72, weight: .thin))
            .foregroundColor(theme.primaryTextColor)
    }

    private var conditionView: some View {
        Text(bundle.current.condition)
            .font(.title3)
            .foregroundColor(theme.secondaryTextColor)
    }

    private var minMaxView: some View {
        HStack(spacing: 16) {
            Label(
                bundle.forecast.first?.maxTemp.tempString ?? "--",
                systemImage: "arrow.up"
            )
            Label(
                bundle.forecast.first?.minTemp.tempString ?? "--",
                systemImage: "arrow.down"
            )
        }
        .font(.subheadline)
        .foregroundColor(theme.secondaryTextColor)
    }
}
