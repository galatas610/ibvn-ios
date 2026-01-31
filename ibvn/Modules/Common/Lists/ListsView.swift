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
    
    // MARK: Initialization
    init(viewModel: ListsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(viewModel.ibvnType.viewTitle)
                        .appFont(.moldin, .regular, size: 48)
                        .padding(.leading)
                        .padding(.bottom, 8)
                    
                    Spacer()
                }
                
                CustomSearchBar(text: $searchText)
                    .padding(.bottom, 8)
                
                buttonsSection
                
                listSection(searchResults)
            }
            .background(Constants.fondoOscuro)
            .modifier(TopBar())
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
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
    
    func listSection(_ searchResults: [CloudPlaylist]) -> some View {
        List {
            ForEach(searchResults, id: \.id) { playlist in
                NavigationLink {
                    ListVideosView(viewModel: ListVideosViewModel(playlist: playlist))
                } label: {
                    labelContent(with: playlist)
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
//        .padding(.horizontal, -16)
        .scrollContentBackground(.hidden)
        .background(Constants.fondoOscuro)
    }
    
    var buttonsSection: some View {
        VStack(spacing: 16) {
            Rectangle()
                .fill(Color.gray.opacity(0.8))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            HStack {
                Text("Ordenar por:")
                    .appFont(.dmSans, .medium, size: 16)
                    .foregroundStyle(.white)
                
                GradientButton(text: "Más reciente", showImage: false) {
                    print("Mas reciente")
                }
                
                OutlineButton(text: "NDVN", showImage: false, fullWidth: false) {
                    print("Noches de Vida Nueva")
                }
                
                OutlineButton(text: "A-Z", showImage: false, fullWidth: false) {
                    print("A-Z")
                }
                
            }
            .padding(.horizontal)
            
            Rectangle()
                .fill(Color.gray.opacity(0.8))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
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
