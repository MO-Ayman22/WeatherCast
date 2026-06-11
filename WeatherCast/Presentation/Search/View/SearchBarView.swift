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

    var body: some View {

        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search city...",
                text: $text
            )

            if !text.isEmpty {

                Button {

                    onClear()

                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
}
