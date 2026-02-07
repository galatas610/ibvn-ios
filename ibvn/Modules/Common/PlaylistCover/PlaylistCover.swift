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
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 154)
                .clipped()
                .cornerRadius(20)
                
                Text(playlist.title)
                    .appFont(.moldin, .medium, size: 40)
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Text(playlist.description)
                    .appFont(.dmSans, .light, size: 14)
                    .foregroundColor(Constants.textoPrincipal)
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [
                    Constants.fondo,
                    Constants.fondo.opacity(0.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
    }
}
