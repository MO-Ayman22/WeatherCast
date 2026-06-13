//
//  WeatherCastApp.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 09/06/2026.
//

import SwiftUI
import UIKit

@main
struct WeatherCastApp: App {

    @StateObject private var container = DIContainer()

    init() {
        configureNavigationBar()
        applyTabBarAppearance(
            colors: [
                UIColor(Color(hex: "#0D1B2A")),
                UIColor(Color(hex: "#1B3A5C"))
            ],
            tint: .white
        )
    }

    var body: some Scene {
        WindowGroup {
        ZStack {
                SplashView()
                    .environmentObject(container)
            }
           
        }
    }
}

// MARK: - Private Helpers
private extension WeatherCastApp {

    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UIView.appearance(whenContainedInInstancesOf: [UINavigationController.self]).backgroundColor = .clear
    }

    func setWindowBackground(_ color: UIColor) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.forEach { $0.backgroundColor = color }
    }
}
