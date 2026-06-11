//
//  SplashView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import SwiftUI

struct SplashView: View {

    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: CGFloat = 0
    @State private var titleOpacity: CGFloat = 0
    @State private var subtitleOpacity: CGFloat = 0
    @State private var glowScale: CGFloat = 1.0
    @State private var isFinished: Bool = false

    private var isMorning: Bool { Date().isMorning }

    private var gradient: LinearGradient {
        isMorning
        ? LinearGradient(
            colors: [Color(hex: "#87CEEB"), Color(hex: "#4A90D9")],
            startPoint: .top,
            endPoint: .bottom
        )
        : LinearGradient(
            colors: [Color(hex: "#0D1B2A"), Color(hex: "#1B3A5C")],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var textColor: Color {
        isMorning ? .black : .white
    }

    private var greetingText: String {
        let hour = Date().hour
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default: return "Good Night"
        }
    }

    private var greetingIcon: String {
        let hour = Date().hour
        switch hour {
        case 5..<12: return "sun.rise.fill"
        case 12..<17: return "sun.max.fill"
        case 17..<21: return "sun.set.fill"
        default: return "moon.stars.fill"
        }
    }

    var body: some View {
        if isFinished {
            ContentView()
        } else {
            splashContent
        }
    }

    private var splashContent: some View {
        ZStack {
            gradient.ignoresSafeArea()

            // Background animation
            if isMorning {
                SunAnimationView()
                    .opacity(0.3)
            } else {
                starParticles
            }

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 120, height: 120)

                    Image(systemName: greetingIcon)
                        .font(.system(size: 55))
                        .foregroundColor(isMorning ? Color(hex: "#FFD700") : .white)
                        .symbolRenderingMode(.multicolor)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                VStack(spacing: 8) {
                    Text("WeatherCast")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(textColor)
                        .opacity(titleOpacity)

                    Text(greetingText)
                        .font(.title3)
                        .foregroundColor(textColor.opacity(0.7))
                        .opacity(subtitleOpacity)
                }

                Spacer()

                Text("Your weather, beautifully displayed")
                    .font(.caption)
                    .foregroundColor(textColor.opacity(0.5))
                    .opacity(subtitleOpacity)
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            animateSplash()
        }
    }

    // MARK: - Star particles for night
    private var starParticles: some View {
        ZStack {
            ForEach(0..<30, id: \.self) { i in
                Circle()
                    .fill(Color.white)
                    .frame(
                        width: CGFloat.random(in: 2...4),
                        height: CGFloat.random(in: 2...4)
                    )
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height * 0.6)
                    )
                    .opacity(Double.random(in: 0.4...1.0))
            }
        }
    }

    // MARK: - Animation sequence
    private func animateSplash() {
        withAnimation(.timingCurve(0.16, 1, 0.3, 1, duration: 0.8)) {
            logoScale = 1.15
            logoOpacity = 1.0
        }

        withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
            logoScale = 1.0
            titleOpacity = 1.0
        }

        withAnimation(.easeIn(duration: 0.5).delay(0.8)) {
            subtitleOpacity = 1.0
        }

        withAnimation(.easeInOut(duration: 0.8).repeatCount(2, autoreverses: true).delay(1.2)) {
            glowScale = 1.06
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            withAnimation(.easeInOut(duration: 0.5)) {
                logoOpacity = 0.0
                titleOpacity = 0.0
                subtitleOpacity = 0.0
                glowScale = 0.9
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.3) {
            isFinished = true
        }
    }
}
