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
        // Navigation bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UIView.appearance(whenContainedInInstancesOf: [UINavigationController.self]).backgroundColor = .clear

        applyDefaultTabBarAppearance()
    }

    private func applyDefaultTabBarAppearance() {
        let gradientImage = makeGradientImage(
            colors: [
                UIColor(Color(hex: "#0D1B2A")),
                UIColor(Color(hex: "#1B3A5C"))
            ],
            size: CGSize(width: UIScreen.main.bounds.width, height: 83)
        )

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundImage = gradientImage
        appearance.shadowImage = UIImage()

        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.4)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.4)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    private func makeGradientImage(colors: [UIColor], size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let cgContext = context.cgContext
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let cgColors = colors.map { $0.cgColor } as CFArray
            guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: cgColors,
                locations: [0, 1]
            ) else { return }
            cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: 0),
                options: []
            )
        }
    }

    var body: some Scene {
            WindowGroup {
                ZStack {
                    Color(hex: "#0D1B2A")
                        .ignoresSafeArea()

                    SplashView()
                        .environmentObject(container)
                }
                .onAppear {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.windows.forEach { window in
                            window.backgroundColor = UIColor(Color(hex: "#0D1B2A"))
                        }
                    }
                }
            }
        }
}
