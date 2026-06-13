//
//  SearchResultsSection.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import SwiftUI

struct SearchResultsSection: View {

    let state: SearchState
    let container: DIContainer
    let theme: WeatherTheme

    var body: some View {
        switch state {
        case .idle:
            EmptyView()

        case .loading:
            VStack(spacing: 16) {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: theme.primaryTextColor))
                    .scaleEffect(1.5)
                Text("Searching...")
                    .font(.subheadline)
                    .foregroundColor(theme.secondaryTextColor)
                Spacer()
            }
            .padding(.top, 60)

        case .success(let cities):
            if cities.isEmpty {
                emptyResults
            } else {
                resultsView(cities: cities)
            }

        case .error(let message):
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 80, height: 80)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.orange)
                }
                Text("Something went wrong")
                    .font(.headline)
                    .foregroundColor(theme.primaryTextColor)
                Text(message)
                    .font(.caption)
                    .foregroundColor(theme.secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 60)
        }
    }

    private var emptyResults: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 80, height: 80)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 36))
                    .foregroundColor(theme.primaryTextColor.opacity(0.5))
            }
            Text("No cities found")
                .font(.headline)
                .foregroundColor(theme.primaryTextColor)
            Text("Try a different city name")
                .font(.caption)
                .foregroundColor(theme.secondaryTextColor)
        }
        .padding(.top, 60)
    }

    private func resultsView(cities: [CityLocation]) -> some View {
        VStack(spacing: 0) {
            ForEach(cities) { city in
                NavigationLink {
                    WeatherDetailsView(city: city, container: container)
                } label: {
                    SearchResultRowView(city: city, theme: theme)
                }
                if city.id != cities.last?.id {
                    Divider()
                        .background(theme.secondaryTextColor.opacity(0.3))
                }
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
