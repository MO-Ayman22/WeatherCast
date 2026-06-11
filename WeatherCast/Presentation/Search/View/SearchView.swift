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

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView

                ScrollView {
                    VStack(spacing: 24) {
                        SearchBarView(
                            text: $viewModel.searchText,
                            onClear: { viewModel.clearSearch() }
                        )

                        if viewModel.searchText.isEmpty {
                            FeaturedCitiesSection()
                        } else {
                            SearchResultsSection(
                                state: viewModel.state,
                                container: container
                            )
                        }
                    }
                    .padding()
                    .padding(.bottom, 80)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
        }.background(
            LinearGradient(
                colors: [Color(hex: "#1B3A5C"), Color(hex: "#0D1B2A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    private var backgroundView: some View {
        LinearGradient(
            colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.5)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
