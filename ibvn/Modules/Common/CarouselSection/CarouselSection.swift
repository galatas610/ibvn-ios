//
//  CarouselSection.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 2/3/26.
//

import Foundation
import SwiftUI

func carouselSection(
    title: String,
    playlists: [CloudPlaylist]
) -> some View {
    
    VStack(alignment: .leading, spacing: 12) {
        HStack {
            Text(title)
                .appFont(.dmSans, .semiBold, size: 16)
                .foregroundColor(.white)
                .padding(.leading)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Constants.fondo)
        .cornerRadius(20)
        .padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(playlists, id: \.id) { playlist in
                    NavigationLink {
                        ListVideosView(
                            playlist: playlist
                        )
                    } label: {
                        RecommendedCardView(playlist: playlist)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
