//
//  WeatherIconView.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 12/06/2026.
//

import Foundation
import SwiftUI

struct WeatherIconView: View {

    let urlString: String
    let size: CGFloat

    init(urlString: String, size: CGFloat = 64) {
        self.urlString = urlString
        self.size = size
    }

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            case .failure:
                Image(systemName: "cloud.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundColor(.white)
            case .empty:
                ProgressView()
                    .frame(width: size, height: size)
            @unknown default:
                EmptyView()
            }
        }
    }
}
