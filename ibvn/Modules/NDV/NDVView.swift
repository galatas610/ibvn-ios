//
//  NDVView.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI

struct NDVView: View {
    @StateObject private var viewModel: NDVViewModel
    
    init(viewModel: NDVViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.ndvVideos.items, id: \.id.videoId) { item in
                    YouTubeVideoView(item: item)
                }
            }
            .padding(.top, 16)
            .navigationTitle("Noche de Viernes")
            .modifier(TopBar())
        }
    }
}

#Preview {
    NDVView(viewModel: NDVViewModel())
}
