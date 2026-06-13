//
//  SearchResultRowView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import SwiftUI

struct SearchResultRowView: View {

    let city: CityLocation
    let theme: WeatherTheme

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                    .foregroundColor(theme.primaryTextColor)
                Text(city.region.isEmpty ? city.country : "\(city.region), \(city.country)")
                    .font(.caption)
                    .foregroundColor(theme.secondaryTextColor)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(theme.secondaryTextColor)
                .font(.caption)
        }
        .padding()
    }
}
