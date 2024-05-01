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
    @State private var searchText = ""
    
    // MARK: Initialization
    init(viewModel: ListVideosViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        ScrollView {
            PlaylistCover(playlist: viewModel.cloudPlaylist)
            
            ForEach(searchResults, id: \.id) { item in
                if viewModel.showPreview {
                    NavigationLink {
                        YouTubeVideoListView(item: item, showPreview: viewModel.showPreview)
                    } label: {
                        labelContent(with: item)
                    }
                } else {
                    YouTubeVideoListView(item: item, showPreview: viewModel.showPreview)
                }
            }
        }
        .padding(.top, 16)
        .navigationBarTitleDisplayMode(.inline)
        .modifier(TopBar())
        .modifier(BackButtonTitleHiddenModifier())
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .showAlert(viewModel.alertInfo, when: $viewModel.alertIsPresenting)
    }
    
    var searchResults: [ListVideosItem] {
        if searchText.isEmpty {
            return viewModel.youtubePlaylist.items
        } else {
            return viewModel.youtubePlaylist.items.filter {
                $0.snippet.title.localizedCaseInsensitiveContains(searchText) ||
                $0.snippet.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    @ViewBuilder
    func labelContent(with item: ListVideosItem) -> some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: item.snippet.thumbnails.medium?.url ?? "")) { image in
                    image.resizable().centerCropped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 66)
                .clipped()
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(item.snippet.title)
                    .font(.caption)
                    .foregroundColor(Constants.primary)
                
                Text(item.snippet.publishedAt.formatDate())
                    .font(.caption2)
                    .foregroundColor(Constants.secondary)
            }
            
            Spacer()
        }
    }
}
