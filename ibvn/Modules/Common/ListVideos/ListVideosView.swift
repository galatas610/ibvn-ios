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
    init(playlist: CloudPlaylist) {
        _viewModel = StateObject(
            wrappedValue: ListVideosViewModel(playlist: playlist)
        )
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            CustomSearchBar(text: $searchText)
                .padding(.bottom, 8)
            
            ScrollView {
                PlaylistCover(playlist: viewModel.cloudPlaylist)
                    .padding(.horizontal)
                
                ForEach(searchResults, id: \.id) { item in
                    if viewModel.showPreview {
                        NavigationLink {
                            VideoView(item: item, showPreview: viewModel.showPreview)
                        } label: {
                            labelContent(with: item)
                        }
                    } else {
                        VideoView(item: item, showPreview: viewModel.showPreview)
                    }
                }
            }
        }
        .background(Constants.fondoOscuro)
        .modifier(TopBar())
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .showAlert(viewModel.alertInfo, when: $viewModel.alertIsPresenting)
        .onAppear {
            viewModel.loadIfNeeded()
        }
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
                    .appFont(.dmSans, .semiBold, size: 16)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Text(item.snippet.publishedAt.formatDate())
                    .appFont(.dmSans, .regular, size: 12)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
    }
}
