//
//  RecommendedView.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 2/3/26.
//

import SwiftUI

struct RecommendedView: View {
    @StateObject private var viewModel = RecommendedViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    title
                    
                    carouselSection(
                        title: "DOMINGOS",
                        playlists: viewModel.sundayPlaylists
                    )
                    .padding(.bottom, 8)
                    
                    carouselSection(
                        title: "NOCHES DE VIDA NUEVA",
                        playlists: viewModel.ndvnPlaylists
                    )
                    
                    List {
                        ForEach(viewModel.pastSeriesPlaylists, id: \.id) { playlist in
                            NavigationLink {
                                ListVideosView(viewModel: ListVideosViewModel(playlist: playlist))
                            } label: {
                                labelContent(with: playlist)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Constants.fondoOscuro)
                }
                .padding(.bottom, 24)
               
            }
            .scrollIndicators(.hidden)
            .background(Constants.fondoOscuro)
            .navigationBarTitleDisplayMode(.inline)
            .modifier(TopBar())
        }
    }
    
    var title: some View {
        HStack {
            Text("Recomendadas")
                .appFont(.moldin, .regular, size: 48)
                .padding(.leading)
                .padding(.bottom, 8)
            
            Spacer()
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
