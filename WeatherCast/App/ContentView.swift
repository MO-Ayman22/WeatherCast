//
//  ContentView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 09/06/2026.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var container: DIContainer

    var body: some View {
        ZStack {
            Color(hex: "#0D1B2A")
                .ignoresSafeArea()

            TabView {
                HomeView(viewModel: HomeViewModel(container: container))
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                SearchView(viewModel: SearchViewModel(container: container))
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }

                SavedLocationsView(viewModel: SavedLocationsViewModel(container: container))
                    .tabItem {
                        Label("Saved", systemImage: "heart.fill")
                    }
            }
        }
    }
}
