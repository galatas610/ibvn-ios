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
            .navigationTitle("Mensajes")
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Image("IbvnLogo")
                        .resizable()
                        .frame(width: 80, height: 21)
                }
            }
        }
        .navigationBarTitleColor(.accentColor)
    }
}

#Preview {
    SundayPreachesView(viewModel: SundayPreachesViewModel())
}
