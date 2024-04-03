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
                    YouTubeVideoListView(item: item)
                }
            }
            .padding(.top, 16)
            .navigationBarTitleDisplayMode(.inline)
            .modifier(TopBar())
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
