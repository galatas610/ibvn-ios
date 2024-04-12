//
//  YouTubePlayer.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI
import YouTubeiOSPlayerHelper

struct YouTubePlayer: UIViewRepresentable {
    @Binding var videoId: String
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        
        playerView.load(withVideoId: videoId)
        
        return playerView
        
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        uiView.load(withVideoId: videoId)
    }
}
