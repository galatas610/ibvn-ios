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
                .tag("1")
            
            ListsView(viewModel: ListsViewModel(ibvnType: .preaches))
                .tabItem {
                    Label("Series", image: "bookOpen")
                }
                .tag("1")
            
            ListsView(viewModel: ListsViewModel(ibvnType: .elRestoDeHoy))
                .tabItem {
                    Label("Podcast", image: "microphone")
                }
                .tag("2")
            
            ListsView(viewModel: ListsViewModel(ibvnType: .nocheDeViernes))
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
