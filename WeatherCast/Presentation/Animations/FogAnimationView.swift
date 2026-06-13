//
//  FogAnimationView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct FogAnimationView: View {

    @State private var phase: CGFloat = 0

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = CGFloat(timeline.date.timeIntervalSinceReferenceDate)

                let x1 = sin(now * 0.1) * 40
                let fog1 = Path(ellipseIn: CGRect(
                    x: size.width * 0.1 + x1,
                    y: size.height * 0.3,
                    width: size.width * 0.8,
                    height: size.height * 0.15
                ))
                context.fill(fog1, with: .color(.white.opacity(0.12)))

                let x2 = cos(now * 0.08) * 50
                let fog2 = Path(ellipseIn: CGRect(
                    x: size.width * 0.05 + x2,
                    y: size.height * 0.5,
                    width: size.width * 0.9,
                    height: size.height * 0.12
                ))
                context.fill(fog2, with: .color(.white.opacity(0.1)))

                let x3 = sin(now * 0.06 + 1) * 30
                let fog3 = Path(ellipseIn: CGRect(
                    x: size.width * 0.0 + x3,
                    y: size.height * 0.65,
                    width: size.width,
                    height: size.height * 0.1
                ))
                context.fill(fog3, with: .color(.white.opacity(0.08)))
            }
        }
        .blur(radius: 20)
        .ignoresSafeArea()
    }
}
