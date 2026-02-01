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
            ListsView(viewModel: ListsViewModel(ibvnType: .series))
                .tabItem {
                    Label("Series", image: "bookOpen")
                }
                .tag("1")
            
            LiveView(viewModel: LiveViewModel(ibvnType: .live))
                .tabItem {
                    Label("Inicio", image: "home")
                }
                .tag("0")
            
            ListsView(viewModel: ListsViewModel(ibvnType: .podcast))
                .tabItem {
                    Label("Podcast", image: "microphone")
                }
                .tag("2")
            
            ListsView(viewModel: ListsViewModel(ibvnType: .recommended))
                .tabItem {
                    Label("Recomendados", image: "bookmarkStar")
                }
                .tag("3")
        }
    }
}

#Preview {
    TabBarView()
}
