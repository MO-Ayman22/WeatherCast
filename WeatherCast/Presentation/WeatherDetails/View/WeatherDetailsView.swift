//
//  WeatherDetailsView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import SwiftUI

struct WeatherDetailsView: View {

    @StateObject private var viewModel: WeatherDetailsViewModel
    @State private var selectedDay: DailyWeather?
    @State private var showHourly = false

    init(city: CityLocation, container: DIContainer) {
        _viewModel = StateObject(
            wrappedValue: container.makeWeatherDetailsViewModel(city: city)
        )
    }

    var body: some View {
        ZStack {
            backgroundView
            contentView

            if showHourly, let day = selectedDay,
               case .success(let bundle) = viewModel.state {
                HourlyView(day: day, isDay: bundle.isDay) {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        showHourly = false
                    }
                }
                .transition(.smoothPush)
                .zIndex(1)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(showHourly)
        .onAppear { viewModel.loadWeather() }
        .alert("Remove Location", isPresented: $viewModel.showRemoveAlert) {
            Button("Remove", role: .destructive) {
                viewModel.confirmRemove()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if case .success(let bundle) = viewModel.state {
                Text("Are you sure you want to remove \(bundle.current.location) from saved locations?")
            }
        }
    }

    // MARK: - Background
    @ViewBuilder
    private var backgroundView: some View {
        if case .success(let bundle) = viewModel.state {
            WeatherBackgroundView(
                condition: bundle.current.weatherCondition,
                isDay: bundle.isDay
            )
            .ignoresSafeArea()
        } else {
            defaultBackground
        }
    }

    private var defaultBackground: some View {
        ZStack {
            defaultGradient
            if Date().isDay {
                SunAnimationView().opacity(0.4)
            } else {
                nightStars
            }
        }
        .ignoresSafeArea()
    }

    private var defaultGradient: some View {
        LinearGradient(
            colors: Date().isDay
                ? [Color(hex: "#87CEEB"), Color(hex: "#4A90D9")]
                : [Color(hex: "#0D1B2A"), Color(hex: "#1B3A5C")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var nightStars: some View {
        let screenWidth = Int(UIScreen.main.bounds.width)
        let screenHeight = Int(UIScreen.main.bounds.height * 0.6)
        return ZStack {
            ForEach(0..<25, id: \.self) { i in
                Circle()
                    .fill(Color.white)
                    .frame(width: CGFloat.random(in: 2...4))
                    .position(
                        x: CGFloat(i * 41 % screenWidth),
                        y: CGFloat(i * 67 % screenHeight)
                    )
                    .opacity(i % 3 == 0 ? 0.9 : 0.4)
            }
        }
    }

    // MARK: - Content
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()

        case .loading:
            loadingView

        case .success(let bundle):
            weatherContent(bundle: bundle)

        case .error(let message):
            errorView(message: message)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            Text("Getting weather details...")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
        }
    }

    private func weatherContent(bundle: WeatherBundle) -> some View {
        let theme = WeatherTheme(isDay: bundle.isDay)
        return ScrollView {
            VStack(spacing: 20) {
                TopSectionView(bundle: bundle, theme: theme)
                ForecastSectionView(
                    bundle: bundle,
                    theme: theme,
                    onDaySelected: { day in
                        selectedDay = day
                        withAnimation(.easeInOut(duration: 0.35)) {
                            showHourly = true
                        }
                    }
                )
                StatsSectionView(current: bundle.current, theme: theme)
            }
            .padding()
            .padding(.bottom, 80)
        }
        .scrollContentBackground(.hidden)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 100, height: 100)
                Image(systemName: "cloud.bolt.rain.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.white)
                    .symbolRenderingMode(.multicolor)
            }
            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(message)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            Button {
                viewModel.loadWeather()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
            Spacer()
        }
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if case .success = viewModel.state {
                Button {
                    viewModel.toggleSave()
                } label: {
                    Image(systemName: viewModel.isSaved ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isSaved ? .red : .white)
                }
                .transition(.opacity)
            }
        }
    }
}
