//
//  LiveView.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import SwiftUI

struct LiveView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: LiveViewModel
    
    // MARK: Initialization
    init(viewModel: LiveViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            VStack {
                if let lastLive = viewModel.youtubeVideo.items.first {
                    VideoLiveView(item: lastLive)
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .navigationTitle(viewModel.youtubeVideo.items.first?.snippet.liveBroadcastContent.title ?? "")
            .padding(.top, 16)
            .modifier(TopBar())
            .onAppear {
                viewModel.fetchCloudLive()
            }
        }
    }
}

#Preview {
    LiveView(viewModel: LiveViewModel(ibvnType: .live))
}
