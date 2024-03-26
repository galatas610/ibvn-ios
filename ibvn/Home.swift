//
//  Home.swift
//  ibvn
//
//  Created by Jose Letona on 25/3/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        YouTubePlayer(videoId: "jQtP1dD6jQ0?")
    }
}

#Preview {
    Home()
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
