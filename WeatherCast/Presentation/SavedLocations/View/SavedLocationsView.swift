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

    private let theme = WeatherTheme(isDay: Date().isDay)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView

                VStack(spacing: 0) {
                    savedHeader
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 12)

                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.savedLocations.isEmpty {
                        emptyState
                    } else {
                        locationsList
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadSavedLocations()
            }
        }
        .background(backgroundView)
    }

    // MARK: - Background
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

    // MARK: - Header
    private var savedHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Saved")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(theme.primaryTextColor)
                Text("\(viewModel.savedLocations.count) location\(viewModel.savedLocations.count == 1 ? "" : "s") saved")
                    .font(.subheadline)
                    .foregroundColor(theme.secondaryTextColor)
            }
            Spacer()
            Image(systemName: "heart.fill")
                .font(.system(size: 36))
                .foregroundColor(.red.opacity(0.8))
        }
    }

    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: theme.primaryTextColor))
                .scaleEffect(1.5)
            Text("Loading saved locations...")
                .font(.subheadline)
                .foregroundColor(theme.secondaryTextColor)
            Spacer()
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 100, height: 100)
                Image(systemName: "heart.slash.fill")
                    .font(.system(size: 44))
                    .foregroundColor(theme.primaryTextColor.opacity(0.5))
            }
            Text("No saved locations yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(theme.primaryTextColor)
            Text("Search for a city and tap ♥ to save it")
                .font(.caption)
                .foregroundColor(theme.secondaryTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }

    // MARK: - Locations List
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
                        SavedLocationRowView(location: location, theme: theme)
                    }
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
        .scrollContentBackground(.hidden)
    }
}
