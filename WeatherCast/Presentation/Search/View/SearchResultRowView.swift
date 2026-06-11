//
//  SearchResultRowView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import SwiftUI

struct SearchResultRowView: View {

    let city: CityLocation

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(city.region.isEmpty ? "" : "\(city.region), ")\(city.country)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
                .font(.caption)
        }
        .padding()
    }
}
