//
//  NDVView.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI

//struct NDVView: View {
//    // MARK: Property Wrappers
//    @StateObject private var viewModel: NDVViewModel
//    @State private var searchText = ""
//    
//    // MARK: Initialization
//    init(viewModel: NDVViewModel) {
//        self._viewModel = StateObject(wrappedValue: viewModel)
//    }
//    
//    // MARK: Body
//    var body: some View {
//        NavigationView {
//            ScrollView {
////                ForEach(searchResults, id: \.id.videoId) { item in
////                    YouTubeVideoView(item: item)
////                }
//            }
//            .padding(.top, 16)
//            .navigationTitle("Noche de Viernes")
//            .modifier(TopBar())
//            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
//        }
//    }
//    
////    var searchResults: [Item] {
////        if searchText.isEmpty {
////            return viewModel.ndvVideos.items
////        } else {
////            return viewModel.ndvVideos.items.filter { $0.snippet.title.localizedCaseInsensitiveContains(searchText) ||
////                $0.snippet.description.localizedCaseInsensitiveContains(searchText)
////            }
////        }
////    }
//}
//
//#Preview {
//    NDVView(viewModel: NDVViewModel())
//}
