//
//  SearchBarView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import SwiftUI

struct SearchBarView: View {

    @Binding var text: String
    let onClear: () -> Void
    let theme: WeatherTheme

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.secondaryTextColor)

            TextField("Search city...", text: $text)
                .foregroundColor(theme.primaryTextColor)
                .tint(theme.primaryTextColor)

            if !text.isEmpty {
                Button { onClear() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(theme.secondaryTextColor)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
