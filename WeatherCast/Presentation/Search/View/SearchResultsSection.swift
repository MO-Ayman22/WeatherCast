//
//  SearchResultsSection.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import SwiftUI

struct SearchResultsSection: View {

    let state: SearchState
    let container: DIContainer

    var body: some View {
        switch state {
        case .idle:
            EmptyView()

        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .padding(.top, 40)

        case .success(let cities):
            if cities.isEmpty {
                emptyResults
            } else {
                resultsView(cities: cities)
            }

        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                Text(message)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
        }
    }

    private var emptyResults: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.6))
            Text("No cities found")
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.top, 40)
    }

    private func resultsView(cities: [CityLocation]) -> some View {
        VStack(spacing: 0) {
            ForEach(cities) { city in
                NavigationLink {
                    WeatherDetailsView(city: city, container: container)
                } label: {
                    SearchResultRowView(city: city)
                }

                if city.id != cities.last?.id {
                    Divider()
                        .background(.white.opacity(0.3))
                }
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
