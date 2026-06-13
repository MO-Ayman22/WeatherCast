//
//  CloudAnimationView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

private struct CloudLayer {
    let speed: CGFloat
    let opacity: CGFloat
    let scale: CGFloat
    let yOffset: CGFloat
}

struct CloudAnimationView: View {

    private let layers: [CloudLayer] = [
        CloudLayer(speed: 30, opacity: 0.9, scale: 1.2, yOffset: 80),
        CloudLayer(speed: 20, opacity: 0.6, scale: 1.0, yOffset: 160),
        CloudLayer(speed: 10, opacity: 0.3, scale: 0.8, yOffset: 240)
    ]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for layer in layers {
                    let rawX = CGFloat(now) * layer.speed
                    let x = rawX.truncatingRemainder(dividingBy: size.width + 200) - 200
                    var ctx = context
                    ctx.opacity = layer.opacity
                    ctx.translateBy(x: x, y: layer.yOffset)
                    ctx.scaleBy(x: layer.scale, y: layer.scale)
                    var path = Path()
                    path.addEllipse(in: CGRect(x: 0,  y: 0,   width: 120, height: 60))
                    path.addEllipse(in: CGRect(x: 30, y: -30, width: 80,  height: 60))
                    path.addEllipse(in: CGRect(x: 70, y: -10, width: 90,  height: 55))
                    ctx.fill(path, with: .color(.white))
                }
            }
        }
        .ignoresSafeArea()
    }
}
