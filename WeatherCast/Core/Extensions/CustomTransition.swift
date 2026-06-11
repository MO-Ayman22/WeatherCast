//
//  CustomTransition.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var smoothPush: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        )
    }

    static var smoothFade: AnyTransition {
        .opacity.animation(.easeInOut(duration: 0.3))
    }
}
