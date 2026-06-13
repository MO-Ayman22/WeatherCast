//
//  FeaturedCitiesCard.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import SwiftUI

struct CityGridCell: View {

    let city: CityLocation
    let theme: WeatherTheme

    private var flagEmoji: String {
        switch city.country {
        case "Egypt":         return "🇪🇬"
        case "United Kingdom":return "🇬🇧"
        case "Japan":         return "🇯🇵"
        case "France":        return "🇫🇷"
        case "USA":           return "🇺🇸"
        case "UAE":           return "🇦🇪"
        case "Australia":     return "🇦🇺"
        case "Russia":        return "🇷🇺"
        case "Canada":        return "🇨🇦"
        case "Germany":       return "🇩🇪"
        case "India":         return "🇮🇳"
        case "South Korea":   return "🇰🇷"
        default:              return "🌍"
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(flagEmoji)
                .font(.system(size: 36))

            Text(city.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(theme.primaryTextColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(city.country)
                .font(.system(size: 9))
                .foregroundColor(theme.secondaryTextColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
