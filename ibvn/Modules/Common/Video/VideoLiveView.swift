//
//  VideoLiveView.swift
//  ibvn
//
//  Created by Jose Letona on 7/4/24.
//

import SwiftUI

struct VideoLiveView: View {
    // MARK: Variables
    var item: VideoItem
    
    // MARK: Body
    var body: some View {
        VStack {
            youTubePlayerView(with: item)
            date(with: item)
            title(with: item)
            description(with: item)
        }
    }
       
    // MARK: Functions
    func youTubePlayerView(with item: VideoItem) -> some View {
        YoutubePlayer(videoId: Binding.constant(item.id))
            .cornerRadius(16)
            .frame(height: 200)
            .padding(.horizontal, 8)
    }
    
    func date(with item: VideoItem) -> some View {
        HStack {
            Text(item.snippet.publishedAt.formatDate())
                .font(.caption)
                .foregroundColor(Constants.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
    func title(with item: VideoItem) -> some View {
        HStack {
            Text(item.snippet.title)
                .foregroundColor(Constants.primary)
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
    
    func description(with item: VideoItem) -> some View {
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
