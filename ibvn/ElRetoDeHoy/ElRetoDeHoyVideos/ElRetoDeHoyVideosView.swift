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
//                VStack {
//                    HStack {
//                        Text(viewModel.snippet.title)
//                            .foregroundColor(Constants.primary)
//                            .font(.caption)
//                        
//                        Spacer()
//                    }
//                    
//                    Text(viewModel.snippet.description)
//                        .foregroundColor(Constants.secondary)
//                        .font(.caption2)
//                }
//                .padding(.horizontal, 8)
                
                ForEach(viewModel.elRetoDeHoyListVideos.items, id: \.id) { item in
                    YouTubePlayer(videoId: item.snippet.resourceID.videoID)
                        .cornerRadius(16)
                        .frame(height: 200)
                        .padding(.horizontal, 8)
                    HStack {
                        Text(item.snippet.publishedAt.formatDate())
                            .font(.caption)
                            .foregroundColor(Constants.secondary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Text(item.snippet.title)
                            .foregroundColor(Constants.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Text(item.snippet.description)
                            .font(.caption)
                            .foregroundColor(Constants.secondary)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 16)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Image("IbvnLogo")
                        .resizable()
                        .frame(width: 80, height: 21)
                }
            }
            .navigationBarBackButtonTitleHidden()
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
