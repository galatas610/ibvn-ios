//
//  VideoLiveView.swift
//  ibvn
//
//  Created by Jose Letona on 7/4/24.
//

import SwiftUI

struct VideoLiveView: View {
    // MARK: Variables
    let live: CloudLive
    
    // MARK: Body
    var body: some View {
        VStack {
            youTubePlayerView(with: live)
                .padding(.bottom, 4)
            
            date(with: live)
                .padding(.leading)
            
            VStack {
                title(with: live)
                    .padding(.bottom, 4)
                
                description(with: live)
            }
            .padding()
            .background(Constants.fondo)
            .cornerRadius(20)
        }
    }
    
    // MARK: Functions
    func youTubePlayerView(with live: CloudLive) -> some View {
        YoutubePlayer(videoId: live.videoId)
            .cornerRadius(16)
            .frame(height: 200)
    }
    
    func date(with live: CloudLive) -> some View {
        HStack {
            Text(live.publishedAt.formatDate())
                .appFont(.dmSans, .medium, size: 16)
                .foregroundStyle(Constants.textoPrincipal)
            
            Spacer()
        }
    }
    
    func title(with live: CloudLive) -> some View {
        HStack {
            Text(live.title)
                .appFont(.dmSans, .bold, size: 18)
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    func description(with live: CloudLive) -> some View {
        HStack {
            Text(live.description)
                .appFont(.dmSans, .medium, size: 14)
                .foregroundStyle(Constants.textoPrincipal)
            
            Spacer()
        }
    }
}
