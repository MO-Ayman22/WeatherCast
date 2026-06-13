//
//  ThunderAnimationView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct ThunderAnimationView: View {

    @State private var flashOpacity: CGFloat = 0

    var body: some View {
        ZStack {
            RainAnimationView()
            Color.white
                .opacity(flashOpacity)
                .ignoresSafeArea()
        }
        .onAppear {
            triggerLightning()
        }
    }

    private func triggerLightning() {
        let delay = Double.random(in: 3...8)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeIn(duration: 0.05)) { flashOpacity = 0.7 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.15)) { flashOpacity = 0 }
                triggerLightning()
            }
        }
    }
}
