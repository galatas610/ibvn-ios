//
//  YoutubeVideoLiveView.swift
//  ibvn
//
//  Created by Jose Letona on 7/4/24.
//

import SwiftUI
struct YoutubeVideoLiveView: View {
    // MARK: Variables
    var item: LiveItem
    
    // MARK: Body
    var body: some View {
        youTubePlayerView(with: item)
        date(with: item)
        title(with: item)
        description(with: item)
    }
    
    // MARK: Functions
    func youTubePlayerView(with item: LiveItem) -> some View {
        YouTubePlayer(videoId: Binding.constant(item.id.videoId))
            .cornerRadius(16)
            .frame(height: 200)
            .padding(.horizontal, 8)
    }
    
    func date(with item: LiveItem) -> some View {
        HStack {
            Text(item.snippet.publishedAt.formatDate())
                .font(.caption)
                .foregroundColor(Constants.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
    func title(with item: LiveItem) -> some View {
        HStack {
            Text(item.snippet.title)
                .foregroundColor(Constants.primary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
    func description(with item: LiveItem) -> some View {
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

//#Preview {
//    YoutubeVideoLiveView()
//}
