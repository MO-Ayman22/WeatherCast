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
        _homeViewModel = StateObject(wrappedValue: container.makeHomeViewModel())
        _searchViewModel = StateObject(wrappedValue: container.makeSearchViewModel())
        _savedViewModel = StateObject(wrappedValue: container.makeSavedLocationsViewModel())
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
