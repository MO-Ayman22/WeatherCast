//
//  SunAnimationView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct SunAnimationView: View {

    @State private var rotation: Double = 0
    @State private var glowScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.15

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.yellow.opacity(glowOpacity))
                .frame(width: 250, height: 250)
                .scaleEffect(glowScale)

            ForEach(0..<8, id: \.self) { i in
                Rectangle()
                    .fill(Color.yellow.opacity(0.4))
                    .frame(width: 3, height: 60)
                    .offset(y: -90)
                    .rotationEffect(.degrees(Double(i) * 45 + rotation))
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#FFD700"), Color(hex: "#FF6B35")],
                        center: .center,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(width: 100, height: 100)
        }
        .onAppear {
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowScale = 1.2
                glowOpacity = 0.3
            }
        }
    }
}
