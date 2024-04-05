//
//  SundayPreachesView.swift
//  ibvn
//
//  Created by Jose Letona on 25/3/24.
//

import SwiftUI

//struct SundayPreachesView: View {
//    @StateObject private var viewModel: SundayPreachesViewModel
//    @State private var searchText = ""
//    
//    init(viewModel: SundayPreachesViewModel) {
//        self._viewModel = StateObject(wrappedValue: viewModel)
//    }
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                ForEach(searchResults, id: \.id.videoId) { item in
//                    YouTubeVideoView(item: item)
//                }
//            }
//            .padding(.top, 16)
//            .navigationTitle("Mensajes")
//            .modifier(TopBar())
//        }
//        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
//        .navigationBarTitleColor(.accentColor)
//    }
//    
//    var searchResults: [Item] {
//        if searchText.isEmpty {
//            return viewModel.youtubeSearch.items
//        } else {
//            return viewModel.youtubeSearch.items.filter { $0.snippet.title.localizedCaseInsensitiveContains(searchText) ||
//                $0.snippet.description.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//    }
//}
//
//#Preview {
//    SundayPreachesView(viewModel: SundayPreachesViewModel())
//}
