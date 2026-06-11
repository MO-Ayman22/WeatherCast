//
//  WeatherCastApp.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 09/06/2026.
//

import SwiftUI

@main
struct WeatherCastApp: App {
    let persistenceController = PersistenceController.shared
   
    init() {
        // Transparent navigation bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance

        // THIS removes the white background from NavigationStack
        UIView.appearance(whenContainedInInstancesOf: [UINavigationController.self]).backgroundColor = .clear
    }
    
    @StateObject private var container = DIContainer()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(container)
        }
    }
}
