//
//  ContentView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 09/06/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var container: DIContainer
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: HomeViewModel(container: container))
                .tag(0)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            Text("Search")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground)) 
                .tag(1)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            Text("Saved")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .tag(2)
                .tabItem {
                    Label("Saved", systemImage: "heart.fill")
                }
        }
    }
}
