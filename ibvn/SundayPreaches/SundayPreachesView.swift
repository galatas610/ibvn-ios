//
//  SundayPreachesView.swift
//  ibvn
//
//  Created by Jose Letona on 25/3/24.
//

import SwiftUI

struct SundayPreachesView: View {
    @StateObject private var viewModel: SundayPreachesViewModel
    
    init(viewModel: SundayPreachesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView{
            ScrollView {
                ForEach(viewModel.youtubeSearch.items, id: \.id.videoId) { item in
                    YouTubePlayer(videoId: item.id.videoId)
                        .cornerRadius(16)
                        .frame(height: 200)
                        .padding(.horizontal, 8)
                    HStack {
                        Text(item.snippet.publishedAt.formatDate())
                            .font(.caption2)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Text(item.snippet.title)
                            .font(.caption2)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Text(item.snippet.description)
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 16)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    SundayPreachesView(viewModel: SundayPreachesViewModel())
}

import YouTubeiOSPlayerHelper

struct YouTubePlayer : UIViewRepresentable {
    var videoId : String
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.load(withVideoId: videoId)
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        //
    }
}
