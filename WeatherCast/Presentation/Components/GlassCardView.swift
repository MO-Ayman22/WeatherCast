//
//  GlassCardView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct GlassCardView<Content: View>: View {

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
    }
}
