//
//  SundayPreachesView.swift
//  ibvn
//
//  Created by Jose Letona on 25/3/24.
//

import SwiftUI

struct SundayPreachesView: View {
    @StateObject private var viewModel: SundayPreachesViewModel
    
    init(viewModel: SundayPreachesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.youtubeSearch.items, id: \.id.videoId) { item in
                   YouTubeVideoView(item: item)
                }
            }
            .padding(.top, 16)
            .navigationTitle("Mensajes")
            .modifier(TopBar())
        }
        .navigationBarTitleColor(.accentColor)
    }
}

#Preview {
    SundayPreachesView(viewModel: SundayPreachesViewModel())
}
