//
//  TabBarView.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//
//
//  TabBarView.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            LiveView(viewModel: LiveViewModel(ibvnType: .live))
                .tabItem {
                    Label("Inicio", image: "home")
                }
                .tag("0")
            
           series
            .tabItem {
                Label("Series", image: "bookOpen")
            }
            .tag("1")
            
           podcast
            .tabItem {
                Label("Podcast", image: "microphone")
            }
            .tag("2")
            
            RecommendedView()
                .tabItem {
                    Label("Recomendadas", image: "bookmarkStar")
                }
                .tag("3")
        }
    }
    
    var series: some View {
        NavigationStack {
            ListsView(
                viewModel: ListsViewModel(ibvnType: .series)
            )
            .navigationDestination(for: CloudPlaylist.self) { playlist in
                ListVideosView(playlist: playlist)
            }
        }
    }
    
    var podcast: some View {
        NavigationStack {
            ListsView(
                viewModel: ListsViewModel(ibvnType: .podcast)
            )
            .navigationDestination(for: CloudPlaylist.self) { playlist in
                ListVideosView(playlist: playlist)
            }
        }
    }
}

#Preview {
    TabBarView()
}
