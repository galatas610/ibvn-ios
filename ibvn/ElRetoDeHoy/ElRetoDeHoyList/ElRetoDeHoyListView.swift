//
//  ElRetoDeHoyListView.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI

struct ElRetoDeHoyListView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel = ElRetoDeHoyListViewModel()
    
    init(viewModel: ElRetoDeHoyListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            Form {
                ForEach(viewModel.elRetoDeHoyLists.items) { item in
                    NavigationLink {
                        ElRetoDeHoyVideosView(viewModel: ElRetoDeHoyVideosViewModel(
                            listId: item.id,
                            snippet: item.snippet
                        ))
                    } label: {
                        labelContent(with: item)
                    }
                }
            }
            .navigationTitle("El Reto de Hoy")
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Image("IbvnLogo")
                        .resizable()
                        .frame(width: 80, height: 21)
                }
            }
        }
    }
    
    // MARK: Functions
    func labelContent(with item: ListItem) -> some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: item.snippet.thumbnails.default.url)) { image in
                    image.resizable().centerCropped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 66)
                .clipped()
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(item.snippet.title)
                    .font(.caption)
                    .foregroundColor(Constants.primary)
                
                Text(item.snippet.publishedAt.formatDate())
                    .font(.caption2)
                    .foregroundColor(Constants.secondary)
            }
        }
    }
}

#Preview {
    ElRetoDeHoyListView(viewModel: ElRetoDeHoyListViewModel())
}
