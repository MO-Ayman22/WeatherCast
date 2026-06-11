import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedDay: DailyWeather? = nil
    @State private var showHourly: Bool = false
    
    var body: some View {
            ZStack {
                NavigationStack {
                    ZStack {
                        backgroundView
                            .ignoresSafeArea()
                        Color.clear
                        contentView
                    }
                    .background(.clear)
                    .toolbarBackground(.hidden, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { toolbarContent }
                    .onAppear { viewModel.loadWeather() }
                }
                .background(.clear)

                if showHourly, let day = selectedDay,
                   case .success(let bundle) = viewModel.state {
                    HourlyView(
                        day: day,
                        isDay: bundle.isDay,
                        onDismiss: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                showHourly = false
                            }
                        }
                    )
                    .transition(.smoothPush)
                    .zIndex(1)
                }
            }
        }

    // MARK: - Background
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
    
    // MARK: - Content
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()

        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)

        case .success(let bundle):
            let theme = WeatherTheme()
            ScrollView {
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

        case .error(let message):
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                Text(message)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button("Retry") {
                    viewModel.loadWeather()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    // MARK: - Toolbar
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.toggleSave()
            } label: {
                Image(systemName: viewModel.isSaved ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isSaved ? .red : .white)
            }
        }
    }
}
