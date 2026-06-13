//
//  SearchView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import SwiftUI

struct SearchView: View {

    @ObservedObject var viewModel: SearchViewModel
    @EnvironmentObject var container: DIContainer

    private let theme = WeatherTheme(isDay: Date().isDay)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView

                VStack(spacing: 0) {
                    searchHeader
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 12)

                    SearchBarView(
                        text: $viewModel.searchText,
                        onClear: { viewModel.clearSearch() },
                        theme: theme
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 12)

                    ScrollView {
                        VStack(spacing: 24) {
                            if viewModel.searchText.isEmpty {
                                FeaturedCitiesSection(theme: theme)
                            } else {
                                SearchResultsSection(
                                    state: viewModel.state,
                                    container: container,
                                    theme: theme
                                )
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationBarHidden(true)
        }
        .background(backgroundView)
    }

    private var backgroundView: some View {
        LinearGradient(
            colors: theme.isDay
                ? [Color(hex: "#87CEEB"), Color(hex: "#4A90D9")]
                : [Color(hex: "#0D1B2A"), Color(hex: "#1B3A5C")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var searchHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("WeatherCast")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(theme.primaryTextColor)
                Text("Search any city worldwide")
                    .font(.subheadline)
                    .foregroundColor(theme.secondaryTextColor)
            }
            Spacer()
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 40))
                .foregroundColor(theme.primaryTextColor.opacity(0.8))
                .symbolRenderingMode(.multicolor)
        }
    }
}
