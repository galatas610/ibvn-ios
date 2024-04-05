//
//  ListVideosView.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import SwiftUI

struct ListVideosView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: ListVideosViewModel
    
    // MARK: Initialization
    init(viewModel: ListVideosViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        ScrollView {
            PlaylistCover(snippet: viewModel.playlist.snippet)
            
            ForEach(viewModel.youtubePlaylistItems.items, id: \.id) { item in
                YouTubeVideoListView(item: item)
            }
        }
        .padding(.top, 16)
        .navigationBarTitleDisplayMode(.inline)
        .modifier(TopBar())
        .modifier(BackButtonTitleHiddenModifier())
    }
}

#Preview {
    ListVideosView(viewModel: ListVideosViewModel(playlist: Item(kind: "", etag: "", listId: ListId(kind: "", playlistId: ""), snippet: Snippet())))
}
