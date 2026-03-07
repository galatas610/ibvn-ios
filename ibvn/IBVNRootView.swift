//
//  IBVNRootView.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 3/7/26.
//

import SwiftUI

struct IBVNRootView: View {
    @State private var path = NavigationPath()
    let viewModel: ListsViewModel

    var body: some View {
        NavigationStack(path: $path) {
            ListsView(viewModel: viewModel)
                .navigationDestination(for: CloudPlaylist.self) { playlist in
                    ListVideosView(playlist: playlist)
                }
        }
    }
}
