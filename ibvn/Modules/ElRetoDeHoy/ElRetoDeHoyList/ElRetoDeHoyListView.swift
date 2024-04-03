//
//  ElRetoDeHoyListView.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI

struct ElRetoDeHoyListView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: ElRetoDeHoyListViewModel
    @State private var searchText = ""
    
    init(viewModel: ElRetoDeHoyListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { item in
                    NavigationLink {
                        ElRetoDeHoyVideosView(viewModel: ElRetoDeHoyVideosViewModel(
                            listId: item.id,
                            snippet: item.snippet
                        ))
                    } label: {
                        labelContent(with: item)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, -16)
            .navigationTitle("El Reto de Hoy")
            .modifier(TopBar())
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        
        var searchResults: [ListItem] {
            if searchText.isEmpty {
                return viewModel.elRetoDeHoyLists.items
            } else {
                return viewModel.elRetoDeHoyLists.items.filter {
                    $0.snippet.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.snippet.description.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    
    // MARK: Functions
    func labelContent(with item: ListItem) -> some View {
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
    ElRetoDeHoyListView(viewModel: ElRetoDeHoyListViewModel())
}
