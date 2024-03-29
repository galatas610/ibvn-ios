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
            SundayPreachesView(viewModel: SundayPreachesViewModel())
                .tabItem {
                    Label("Mensajes", systemImage: "house")
                }
                .tag("0")
            
            ElRetoDeHoyListView(viewModel: ElRetoDeHoyListViewModel())
                .tabItem {
                    Label("ERDH", systemImage: "bell")
                }
                .tag("1")
            NDVView(viewModel: NDVViewModel())
                .tabItem {
                    Label("NDV", systemImage: "book")
                }
                .tag("2")
            KoinoniaView(viewModel: KoinoniaViewModel())
                .tabItem {
                    Label("Koinonia", systemImage: "figure.2.and.child.holdinghands")
                }
                .tag("3")
        }
    }
}

#Preview {
    TabBarView()
}
