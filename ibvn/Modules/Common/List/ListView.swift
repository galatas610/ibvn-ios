//
//  ListView.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import SwiftUI

struct ListView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: ListViewModel
    @State private var searchText = ""
    
    init(viewModel: ListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { item in
                    NavigationLink {
                        ListVideosView(viewModel: ListVideosViewModel(playlist: item))
                    } label: {
                        labelContent(with: item)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, -16)
            .navigationTitle(viewModel.ibvnType.viewTitle)
            .modifier(TopBar())
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        
        var searchResults: [Item] {
            if searchText.isEmpty {
                return viewModel.youtubePlaylists.items
            } else {
                return viewModel.youtubePlaylists.items.filter {
                    $0.snippet.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.snippet.description.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    
    // MARK: Functions
    func labelContent(with item: Item) -> some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: item.snippet.thumbnails.default.url)) { image in
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
        }
    }
}

#Preview {
    ListView(viewModel: ListViewModel(ibvnType: .elRestoDeHoy))
}
