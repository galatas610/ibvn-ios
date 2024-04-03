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
            elRetoDeHoyCover(with: viewModel.snippet)
            ForEach(viewModel.elRetoDeHoyListVideos.items, id: \.id) { item in
                YouTubeVideoListView(item: item)
            }
        }
        .padding(.top, 16)
        .navigationBarTitleDisplayMode(.inline)
        .modifier(TopBar())
        .modifier(BackButtonTitleHiddenModifier())
        .onAppear {
            Task {
                await viewModel.fetchElRetoDeHoyPlaylistsVideos()
            }
        }
    }
    
    // MARK: Functions
    func elRetoDeHoyCover(with snippet: Snippet) -> some View {
        VStack {
            VStack {
                AsyncImage(url: URL(string: snippet.thumbnails.high.url)) { image in
                    image.resizable().centerCropped()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .cornerRadius(8)
               
                Text(snippet.title)
                    .bold()
                    .foregroundColor(Constants.primaryDark)
                    .padding(.bottom, 8)
                
                Text(snippet.description)
                    .foregroundColor(Constants.secondaryDark)
                    .font(.caption)
                
                HStack {
                    Spacer()
                    
                    Text(snippet.publishedAt.formatDate())
                        .foregroundColor(Constants.secondaryDark)
                        .font(.caption2)
                }
                .padding(.vertical, 8)
            }
            .padding()
        }
        .background(Constants.primary)
        .cornerRadius(20)
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
    }
}

#Preview {
    ElRetoDeHoyVideosView(viewModel: ElRetoDeHoyVideosViewModel(listId: "PL0MA6QqbTGP68oH-8pef_-0w5kGOLN4Eb", snippet: Snippet()))
}
