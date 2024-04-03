//
//  YouTubeVideoListView.swift
//  ibvn
//
//  Created by Jose Letona on 2/4/24.
//

import SwiftUI

// MARK: YouTube Standard Cell View
struct YouTubeVideoListView: View {
    // MARK: Variables
    let item: ListVideosItem
    
    // MARK: Body
    var body: some View {
        youTubePlayerView(with: item)
        date(with: item)
        title(with: item)
        description(with: item)
    }
    
    // MARK: Functions
    func youTubePlayerView(with item: ListVideosItem) -> some View {
        YouTubePlayer(videoId: item.snippet.resourceID.videoID)
            .cornerRadius(16)
            .frame(height: 200)
            .padding(.horizontal, 8)
    }
    
    func date(with item: ListVideosItem) -> some View {
        HStack {
            Text(item.snippet.publishedAt.formatDate())
                .font(.caption)
                .foregroundColor(Constants.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
    func title(with item: ListVideosItem) -> some View {
        HStack {
            Text(item.snippet.title)
                .foregroundColor(Constants.primary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
    func description(with item: ListVideosItem) -> some View {
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
