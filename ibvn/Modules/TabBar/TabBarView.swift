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
                    Label("En Vivo", systemImage: "livephoto")
                }
                .tag("1")
            
            ListsView(viewModel: ListsViewModel(ibvnType: .preaches))
                .tabItem {
                    Label("Mensajes", systemImage: "house")
                }
                .tag("1")
            
            ListsView(viewModel: ListsViewModel(ibvnType: .elRestoDeHoy))
                .tabItem {
                    Label("ERDH", systemImage: "bell")
                }
                .tag("2")
            
            ListsView(viewModel: ListsViewModel(ibvnType: .nocheDeViernes))
                .tabItem {
                    Label("NDV", systemImage: "book")
                }
                .tag("3")
            CampusView(viewModel: CampusViewModel())
                .tabItem {
                    Label("Ubicación", systemImage: "location")
                }
                .tag("4")
        }
    }
}

#Preview {
    TabBarView()
}
