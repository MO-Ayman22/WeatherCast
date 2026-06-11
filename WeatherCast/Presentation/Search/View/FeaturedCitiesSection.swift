//
//  FeaturedCitiesSection.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//
import SwiftUI

struct FeaturedCitiesSection: View {

    @EnvironmentObject var container: DIContainer

    private let cities: [CityLocation] = [
        CityLocation(id: 1, name: "Cairo", region: "", country: "Egypt", lat: 30.0444, lon: 31.2357),
        CityLocation(id: 2, name: "London", region: "", country: "United Kingdom", lat: 51.5072, lon: -0.1276),
        CityLocation(id: 3, name: "Tokyo", region: "", country: "Japan", lat: 35.6764, lon: 139.6500),
        CityLocation(id: 4, name: "Paris", region: "", country: "France", lat: 48.8566, lon: 2.3522),
        CityLocation(id: 5, name: "New York", region: "", country: "USA", lat: 40.7128, lon: -74.0060),
        CityLocation(id: 6, name: "Dubai", region: "", country: "UAE", lat: 25.2048, lon: 55.2708),
        CityLocation(id: 7, name: "Sydney", region: "", country: "Australia", lat: -33.8688, lon: 151.2093),
        CityLocation(id: 8, name: "Moscow", region: "", country: "Russia", lat: 55.7558, lon: 37.6173),
        CityLocation(id: 9, name: "Toronto", region: "", country: "Canada", lat: 43.6532, lon: -79.3832),
        CityLocation(id: 10, name: "Berlin", region: "", country: "Germany", lat: 52.5200, lon: 13.4050),
        CityLocation(id: 11, name: "Mumbai", region: "", country: "India", lat: 19.0760, lon: 72.8777),
        CityLocation(id: 12, name: "Seoul", region: "", country: "South Korea", lat: 37.5665, lon: 126.9780),
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Explore Cities")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Tap any city to view its weather")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }

            // Grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(cities) { city in
                    NavigationLink {
                        WeatherDetailsView(city: city, container: container)
                    } label: {
                        CityGridCell(city: city)
                    }
                }
            }
        }
    }
}
