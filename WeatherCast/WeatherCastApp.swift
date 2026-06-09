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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
