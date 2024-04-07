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
            
            ListView(viewModel: ListViewModel(ibvnType: .preaches))
                .tabItem {
                    Label("Mensajes", systemImage: "house")
                }
                .tag("1")
            
            ListView(viewModel: ListViewModel(ibvnType: .elRestoDeHoy))
                .tabItem {
                    Label("ERDH", systemImage: "bell")
                }
                .tag("2")
            
            ListView(viewModel: ListViewModel(ibvnType: .nocheDeViernes))
                .tabItem {
                    Label("NDV", systemImage: "book")
                }
                .tag("3")
        }
    }
}

#Preview {
    TabBarView()
}
