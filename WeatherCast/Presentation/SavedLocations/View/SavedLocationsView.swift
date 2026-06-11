//
//  SavedLocationsView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import SwiftUI

struct SavedLocationsView: View {

    @ObservedObject var viewModel: SavedLocationsViewModel
    @EnvironmentObject var container: DIContainer

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)

                } else if viewModel.savedLocations.isEmpty {
                    emptyState

                } else {
                    locationsList
                }
            }
            .navigationTitle("Saved")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear { viewModel.loadSavedLocations() }
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
            colors: [Color(hex: "#1B3A5C"), Color(hex: "#0D1B2A")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.4))
            Text("No saved locations yet")
                .font(.title3)
                .foregroundColor(.white.opacity(0.6))
            Text("Search for a city and tap the heart to save it")
                .font(.caption)
                .foregroundColor(.white.opacity(0.4))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    private var locationsList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.savedLocations) { location in
                    NavigationLink {
                        WeatherDetailsView(
                            city: CityLocation(
                                id: 0,
                                name: location.location,
                                region: "",
                                country: "",
                                lat: location.lat,
                                lon: location.lon
                            ),
                            container: container
                        )
                    } label: {
                        SavedLocationRowView(location: location)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            if let index = viewModel.savedLocations.firstIndex(where: {
                                $0.id == location.id
                            }) {
                                viewModel.removeLocation(at: IndexSet([index]))
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
        .scrollContentBackground(.hidden)
    }
}
