//
//  RecommendedCardView.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 2/3/26.
//

import SwiftUI

struct RecommendedCardView: View {
    let playlist: CloudPlaylist

    var body: some View {
        AsyncImage(url: URL(string: playlist.thumbnailUrl)) { image in
            image
                .resizable()
                .centerCropped()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 280, height: 160)
        .cornerRadius(12)
    }
}
