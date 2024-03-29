//
//  KoinoniaView.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI

struct KoinoniaView: View {
    @StateObject private var viewModel: KoinoniaViewModel
    
    init(viewModel: KoinoniaViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView{
            ScrollView {
                ForEach(viewModel.koinoniaVideos.items, id: \.id.videoId) { item in
                    YouTubePlayer(videoId: item.id.videoId)
                        .cornerRadius(16)
                        .frame(height: 200)
                        .padding(.horizontal, 8)
                    HStack {
                        Text(item.snippet.publishedAt.formatDate())
                            .font(.caption)
                            .foregroundColor(Constants.secondary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Text(item.snippet.title)
                            .foregroundColor(Constants.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Text(item.snippet.description)
                            .font(.caption)
                            .foregroundColor(Constants.secondary)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 16)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Koinonia")
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Image("IbvnLogo")
                        .resizable()
                        .frame(width: 80, height: 21)
                }
            }
        }
    }
}

#Preview {
    KoinoniaView(viewModel: KoinoniaViewModel())
}
