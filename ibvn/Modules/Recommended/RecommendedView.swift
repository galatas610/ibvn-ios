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
                    .padding(.top, -16)
                    
                    carouselSection(
                        title: "NOCHES DE VIDA NUEVA",
                        playlists: viewModel.ndvnPlaylists
                    )
                    
                    recommendedList
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
                .appFont(.dmSans, .black, size: 32).tracking(-2)
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
                    .multilineTextAlignment(.leading)
                    .appFont(.dmSans, .medium, size: 16)
                    .foregroundColor(.white)
                
                Text(item.publishedAt.formatDate())
                    .appFont(.dmSans, .regular, size: 12)
                    .foregroundColor(Constants.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var recommendedList: some View {
        HStack {
            Text("SERIES PASADAS")
                .appFont(.dmSans, .semiBold, size: 16)
                .foregroundColor(.white)
                .padding(.leading)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Constants.fondo)
        .cornerRadius(20)
        .padding(.horizontal)
        
        LazyVStack(alignment: .leading) {
            ForEach(viewModel.pastSeriesPlaylists, id: \.id) { playlist in
                NavigationLink {
                    ListVideosView(playlist: playlist)
                } label: {
                    labelContent(with: playlist)
                }
                .listRowBackground(Color.clear)
                
                let isLast = playlist.id == viewModel.pastSeriesPlaylists.last?.id
                
                if !isLast {
                    Divider()
                        .frame(height: 1)
                        .background(Color.white)
                        .opacity(0.3)
                }
            }
            .listStyle(.plain)
            .background(Constants.fondoOscuro)
        }
        .padding(.horizontal)
        .padding(.top, -8)
    }
}
