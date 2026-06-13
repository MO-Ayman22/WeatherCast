//
//  RainAnimationView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct Raindrop {
    let x: CGFloat
    let startY: CGFloat
    let speed: CGFloat
    let opacity: CGFloat
    let length: CGFloat

    static func generate(count: Int = 80) -> [Raindrop] {
        (0..<count).map { _ in
            Raindrop(
                x: CGFloat.random(in: 0...1),
                startY: CGFloat.random(in: 0...1),
                speed: CGFloat.random(in: 200...400),
                opacity: CGFloat.random(in: 0.3...0.7),
                length: CGFloat.random(in: 15...25)
            )
        }
    }
}

struct RainAnimationView: View {

    private let drops = Raindrop.generate()

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for drop in drops {
                    let x = drop.x * size.width
                    let rawY = drop.startY * size.height + CGFloat(now) * drop.speed
                    let y = rawY.truncatingRemainder(dividingBy: size.height)
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x - 4, y: y + drop.length))
                    context.stroke(
                        path,
                        with: .color(.white.opacity(drop.opacity)),
                        lineWidth: 1.5
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}
