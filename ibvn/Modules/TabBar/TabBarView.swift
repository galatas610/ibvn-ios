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
            ListView(viewModel: ListViewModel(ibvnType: .preaches))
                .tabItem {
                    Label("Mensajes", systemImage: "house")
                }
                .tag("0")
            
            ListView(viewModel: ListViewModel(ibvnType: .elRestoDeHoy))
                .tabItem {
                    Label("ERDH", systemImage: "bell")
                }
                .tag("1")
            
            ListView(viewModel: ListViewModel(ibvnType: .nocheDeViernes))
                .tabItem {
                    Label("NDV", systemImage: "book")
                }
                .tag("2")
        }
    }
}

#Preview {
    TabBarView()
}
