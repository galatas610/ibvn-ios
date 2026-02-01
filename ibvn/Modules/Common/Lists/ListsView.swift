//
//  ListsView.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import SwiftUI

struct ListsView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: ListsViewModel
    @State private var searchText = ""
    @State private var selectedSort: PlaylistSortType = .mostRecent
    @State private var selectedSeriesFilter: SeriesFilterType = .allSeries
    
    // MARK: Initialization
    init(viewModel: ListsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            VStack {
                content
                
                listSection(searchResults)
            }
            .background(Constants.fondoOscuro)
            .modifier(TopBar())
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedSort) { newSort in
                withAnimation(.easeInOut) {
                    switch newSort {
                    case .mostRecent:
                        viewModel.sortVisibleListByMostRecent()
                    case .alphabetical:
                        viewModel.sortVisibleListAlphabetical()
                    }
                }
            }
            .onChange(of: selectedSeriesFilter) { newFilter in
                withAnimation(.easeInOut) {
                    switch newFilter {
                    case .allSeries:
                        viewModel.showAllSeries()
                    case .ndvn:
                        viewModel.showNDVNLists()
                    }
                }
            }
        }
        
        var searchResults: [CloudPlaylist] {
            if searchText.isEmpty {
                return viewModel.visiblePlaylists
            } else {
                return viewModel.visiblePlaylists.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.description.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        title
        
        CustomSearchBar(text: $searchText)
            .padding(.bottom, 8)
        
        sortSegmentedControl
        
        seriesFilterSegmentedControl
    }
    
    var title: some View {
        HStack {
            Text(viewModel.ibvnType.viewTitle)
                .appFont(.moldin, .regular, size: 48)
                .padding(.leading)
                .padding(.bottom, 8)
            
            Spacer()
        }
    }
    
    func listSection(_ searchResults: [CloudPlaylist]) -> some View {
        List {
            ForEach(searchResults, id: \.id) { playlist in
                NavigationLink {
                    ListVideosView(viewModel: ListVideosViewModel(playlist: playlist))
                } label: {
                    labelContent(with: playlist)
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Constants.fondoOscuro)
    }
    
    private var sortSegmentedControl: some View {
        Picker("Ordenar", selection: $selectedSort) {
            ForEach(PlaylistSortType.allCases, id: \.self) { sort in
                Text(sort.rawValue).tag(sort)
            }
        }
        .pickerStyle(.segmented)
        .background(Constants.fondoOscuro)
        .tint(Constants.acentoVerde)
        .padding(.horizontal)
    }
    
    var seriesFilterSegmentedControl: some View {
        Picker("Filtrar series", selection: $selectedSeriesFilter) {
            ForEach(SeriesFilterType.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    // MARK: Functions
    func labelContent(with item: CloudPlaylist) -> some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: item.thumbnailUrl)) { image in
                    image.resizable().centerCropped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 66)
                .clipped()
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.caption)
                    .foregroundColor(Constants.primary)
                
                Text(item.publishedAt.formatDate())
                    .font(.caption2)
                    .foregroundColor(Constants.secondary)
            }
        }
    }
}

enum PlaylistSortType: String, CaseIterable {
    case mostRecent = "Más reciente"
    case alphabetical = "A–Z"
}

enum SeriesFilterType: String, CaseIterable {
    case allSeries = "Todas las Series"
    case ndvn = "NDVN"
}
