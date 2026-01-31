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
                .padding(.bottom, 20)
            
            date(with: item)
                .padding(.leading)
            
            VStack {
                title(with: item)
                    .padding(.bottom)
                
                description(with: item)
            }
            .padding()
            .background(Constants.fondo)
            .cornerRadius(20)
        }
    }
    
    // MARK: Functions
    func youTubePlayerView(with item: VideoItem) -> some View {
        YoutubePlayer(videoId: item.id)
            .cornerRadius(16)
            .frame(height: 200)
            .padding(.horizontal, 8)
    }
    
    func date(with item: VideoItem) -> some View {
        HStack {
            Text(item.snippet.publishedAt.formatDate())
                .appFont(.dmSans, .medium, size: 16)
                .foregroundStyle(Constants.textoPrincipal)
            
            Spacer()
        }
    }
    
    func title(with item: VideoItem) -> some View {
        HStack {
            Text(item.snippet.title)
                .appFont(.dmSans, .bold, size: 18)
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    func description(with item: VideoItem) -> some View {
        HStack {
            Text(item.snippet.description)
                .appFont(.dmSans, .medium, size: 14)
                .foregroundStyle(Constants.textoPrincipal)
            
            Spacer()
        }
    }
}
