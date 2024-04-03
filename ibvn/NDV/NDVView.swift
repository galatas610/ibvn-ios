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
            .navigationTitle("Noche de Viernes")
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
    NDVView(viewModel: NDVViewModel())
}
