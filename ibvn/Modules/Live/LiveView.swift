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
            
            VStack(alignment: .leading) {
                Text(viewModel.youtubeVideo.items.first?.snippet.liveBroadcastContent.title ?? "")
                    .appFont(.moldin, .regular, size: 48)
                    .padding(.leading)
                
                if let lastLive = viewModel.youtubeVideo.items.first {
                    VideoLiveView(item: lastLive)
                        .padding()
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 16)
            .modifier(TopBar())
            .onAppear {
                viewModel.fetchCloudLive()
            }
            .background(Constants.fondoOscuro)
        }
    }
}

#Preview {
    LiveView(viewModel: LiveViewModel(ibvnType: .live))
}
