//
//  StatTileView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

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
