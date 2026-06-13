//
//  ContentView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 09/06/2026.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var container: DIContainer

    @StateObject private var homeViewModel: HomeViewModel
    @StateObject private var searchViewModel: SearchViewModel
    @StateObject private var savedViewModel: SavedLocationsViewModel

    init(container: DIContainer) {
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(container: container))
        _searchViewModel = StateObject(wrappedValue: SearchViewModel(container: container))
        _savedViewModel = StateObject(wrappedValue: SavedLocationsViewModel(container: container))
    }

    var body: some View {
        ZStack {
            TabView {
                HomeView(viewModel: homeViewModel)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                SearchView(viewModel: searchViewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }

                SavedLocationsView(viewModel: savedViewModel)
                    .tabItem {
                        Label("Saved", systemImage: "heart")
                    }
            }
        }
    }
}
