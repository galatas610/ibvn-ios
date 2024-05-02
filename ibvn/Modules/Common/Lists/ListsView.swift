//
//  ListsView.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import SwiftUI

struct ListsView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: ListsViewModel
    @State private var searchText = ""
    
    init(viewModel: ListsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.id) { playlist in
                    NavigationLink {
                        ListVideosView(viewModel: ListVideosViewModel(playlist: playlist))
                    } label: {
                        labelContent(with: playlist)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, -16)
            .navigationTitle(viewModel.ibvnType.viewTitle)
            .modifier(TopBar())
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        
        var searchResults: [CloudPlaylist] {
            if searchText.isEmpty {
                return viewModel.cloudPlaylists
            } else {
                return viewModel.cloudPlaylists.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.description.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    
    // MARK: Functions
    func labelContent(with item: CloudPlaylist) -> some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: item.thumbnailUrl)) { image in
                    image.resizable().centerCropped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 66)
                .clipped()
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.caption)
                    .foregroundColor(Constants.primary)
                
                Text(item.publishedAt.formatDate())
                    .font(.caption2)
                    .foregroundColor(Constants.secondary)
            }
        }
    }
}

#Preview {
    ListsView(viewModel: ListsViewModel(ibvnType: .elRestoDeHoy))
}
