//
//  SnowAnimationView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct Snowflake {
    let x: CGFloat
    let startY: CGFloat
    let size: CGFloat
    let speed: CGFloat
    let phaseOffset: CGFloat

    static func generate(count: Int = 60) -> [Snowflake] {
        (0..<count).map { _ in
            Snowflake(
                x: CGFloat.random(in: 0...1),
                startY: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 3...8),
                speed: CGFloat.random(in: 40...80),
                phaseOffset: CGFloat.random(in: 0...(.pi * 2))
            )
        }
    }
}

struct SnowAnimationView: View {

    private let flakes = Snowflake.generate()

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for flake in flakes {
                    let drift = sin(CGFloat(now) * 0.5 + flake.phaseOffset) * 20
                    let x = flake.x * size.width + drift
                    let rawY = flake.startY * size.height + CGFloat(now) * flake.speed
                    let y = rawY.truncatingRemainder(dividingBy: size.height)
                    let rect = CGRect(
                        x: x - flake.size / 2,
                        y: y - flake.size / 2,
                        width: flake.size,
                        height: flake.size
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(.white.opacity(0.8))
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}
