//
//  SavedLocationRowView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import SwiftUI

struct SavedLocationRowView: View {

    let location: SavedLocation

    var body: some View {
        HStack(spacing: 16) {
            WeatherIconView(urlString: location.iconURL, size: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(location.location)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(location.condition)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Text(location.temperature.tempString)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
