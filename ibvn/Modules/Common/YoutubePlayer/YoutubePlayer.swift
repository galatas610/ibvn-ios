//
//  YoutubePlayer.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI
import YouTubeiOSPlayerHelper

struct YoutubePlayer: UIViewRepresentable {

    let videoId: String

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> YTPlayerView {
        let player = YTPlayerView()
        context.coordinator.currentVideoId = videoId
        
        player.load(
            withVideoId: videoId,
            playerVars: [
                "playsinline": 1,
                "autoplay": 0,
                "controls": 1,
                "rel": 0
            ]
        )

        return player
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        // 🔥 Reload only if videoId changed
        if context.coordinator.currentVideoId != videoId {
            
            context.coordinator.currentVideoId = videoId
            
            uiView.load(
                withVideoId: videoId,
                playerVars: [
                    "playsinline": 1,
                    "autoplay": 0,
                    "controls": 1,
                    "rel": 0
                ]
            )
        }
    }

    class Coordinator {
        var currentVideoId: String?
    }
}
