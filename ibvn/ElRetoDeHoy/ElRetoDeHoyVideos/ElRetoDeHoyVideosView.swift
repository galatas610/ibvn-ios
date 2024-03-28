//
//  ElRetoDeHoyVideosView.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI

struct ElRetoDeHoyVideosView: View {
    // MARK: Propery Wrappers
    @StateObject private var viewModel: ElRetoDeHoyVideosViewModel
    
    init(viewModel: ElRetoDeHoyVideosViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
            ScrollView {
                ForEach(viewModel.elRetoDeHoyListVideos.items, id: \.id) { item in
                    YouTubePlayer(videoId: item.snippet.resourceID.videoID)
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
            .navigationTitle(viewModel.snippet.title)
            .navigationBarTitleDisplayMode(.inline)
        
        .onAppear {
            Task {
                await viewModel.fetchElRetoDeHoyPlaylistsVideos()
            }
        }
    }
}

#Preview {
    ElRetoDeHoyVideosView(viewModel: ElRetoDeHoyVideosViewModel(listId: "PL0MA6QqbTGP68oH-8pef_-0w5kGOLN4Eb", snippet: Snippet()))
}
