//
//  YouTubeVideoView.swift
//  ibvn
//
//  Created by Jose Letona on 2/4/24.
//

import SwiftUI

// MARK: YouTube Standard Cell View
struct YouTubeVideoView: View {
    // MARK: Variables
    let item: Item
    
    // MARK: Body
    var body: some View {
        youTubePlayerView(with: item)
        date(with: item)
        title(with: item)
        description(with: item)
    }
    
    // MARK: Functions
    func youTubePlayerView(with item: Item) -> some View {
        YouTubePlayer(videoId: item.id.videoId)
            .cornerRadius(16)
            .frame(height: 200)
            .padding(.horizontal, 8)
    }
    
    func date(with item: Item) -> some View {
        HStack {
            Text(item.snippet.publishedAt.formatDate())
                .font(.caption)
                .foregroundColor(Constants.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
    func title(with item: Item) -> some View {
        HStack {
            Text(item.snippet.title)
                .foregroundColor(Constants.primary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
    func description(with item: Item) -> some View {
        HStack {
            Text(item.snippet.description)
                .font(.caption)
                .foregroundColor(Constants.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 16)
    }
}
