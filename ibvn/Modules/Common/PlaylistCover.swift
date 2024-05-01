//
//  PlaylistCover.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import SwiftUI

struct PlaylistCover: View {
    let playlist: CloudPlaylist
    
    var body: some View {
        VStack {
            VStack {
                AsyncImage(url: URL(string: playlist.thumbnailUrl)) { image in
                    image.resizable().centerCropped()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .cornerRadius(8)
                
                Text(playlist.title)
                    .bold()
                    .foregroundColor(Constants.primaryDark)
                    .padding(.bottom, 8)
                
                Text(playlist.description)
                    .foregroundColor(Constants.secondaryDark)
                    .font(.caption)
                
                HStack {
                    Spacer()
                    
                    Text(playlist.publishedAt.formatDate())
                        .foregroundColor(Constants.secondaryDark)
                        .font(.caption2)
                }
                .padding(.vertical, 8)
            }
            .padding()
        }
        .background(Constants.primary)
        .cornerRadius(20)
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
    }
}
