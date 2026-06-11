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

    init(
        city: CityLocation,
        container: DIContainer
    ) {
        _viewModel = StateObject(
            wrappedValue: WeatherDetailsViewModel(
                city: city,
                container: container
            )
        )
    }

    var body: some View {

        ZStack {

            backgroundView
            contentView
            
            if showHourly,
               let day = selectedDay,
               case .success(let bundle) = viewModel.state {

                HourlyView(
                    day: day,
                    isDay: bundle.isDay
                ) {

                    withAnimation(.easeInOut(duration: 0.35)) {
                        showHourly = false
                    }
                }
                .transition(.smoothPush)
                .zIndex(1)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContent
        }
        .navigationBarBackButtonHidden(showHourly)
        .onAppear {
            viewModel.loadWeather()
        }

        
    }
}


extension WeatherDetailsView {

    @ViewBuilder
    private var backgroundView: some View {

        switch viewModel.state {

        case .success(let bundle):

            WeatherBackgroundView(
                condition: bundle.current.weatherCondition,
                isDay: bundle.isDay
            )
            .ignoresSafeArea()

        default:

            Color(.systemBackground)
                .ignoresSafeArea()
        }
    }
}

extension WeatherDetailsView {

    @ViewBuilder
    private var contentView: some View {

        switch viewModel.state {

        case .idle:

            EmptyView()

        case .loading:

            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(
                        tint: .white
                    )
                )
                .scaleEffect(1.5)

        case .success(let bundle):

            let theme = WeatherTheme()

            ScrollView {

                VStack(spacing: 20) {

                    TopSectionView(
                        bundle: bundle,
                        theme: theme
                    )

                    ForecastSectionView(
                        bundle: bundle,
                        theme: theme
                    ) { day in

                        selectedDay = day

                        withAnimation(
                            .easeInOut(duration: 0.35)
                        ) {

                            showHourly = true
                        }
                    }

                    StatsSectionView(
                        current: bundle.current,
                        theme: theme
                    )
                }
                .padding()
                .padding(.bottom, 80)
            }

        case .error(let message):

            VStack(spacing: 16) {

                Image(
                    systemName:
                        "exclamationmark.triangle.fill"
                )
                .font(.system(size: 50))
                .foregroundColor(.orange)

                Text(message)
                    .multilineTextAlignment(.center)

                Button("Retry") {

                    viewModel.loadWeather()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

extension WeatherDetailsView {

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {

        ToolbarItem(
            placement: .navigationBarTrailing
        ) {

            Button {

                viewModel.toggleSave()

            } label: {

                Image(
                    systemName:
                        viewModel.isSaved
                        ? "heart.fill"
                        : "heart"
                )
                .foregroundColor(
                    viewModel.isSaved
                    ? .red
                    : .white
                )
            }
        }
    }
}
