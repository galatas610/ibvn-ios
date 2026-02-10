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
    @State private var selectedFilter: PodcastFilterType = .allPodcast
    
    // MARK: Initialization
    init(viewModel: ListsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            VStack {
                content
                
                listSection(searchResults)
            }
            .background(Constants.fondoOscuro)
            .modifier(TopBar())
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedSort) { _ in
                apply()
            }
            .onChange(of: selectedSeriesFilter) { _ in
                apply()
            }
            .onChange(of: selectedFilter) { _ in
                apply()
            }
            .showAlert(viewModel.alertInfo, when: $viewModel.alertIsPresenting)
            .navigationDestination(for: CloudPlaylist.self) { playlist in
                ListVideosView(playlist: playlist)
            }
        }
        
        var searchResults: [CloudPlaylist] {
            guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return viewModel.visiblePlaylists
            }
            
            let tokens = searchText
                .normalizedForSearch()
                .split(separator: " ")
                .map(String.init)
            
            return viewModel.visiblePlaylists.filter { playlist in
                let words = (playlist.title + " " + playlist.description)
                    .normalizedForSearch()
                    .split(separator: " ")
                
                return tokens.allSatisfy { token in
                    words.contains { word in
                        String(word).starts(with: token)
                    }
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
    
    private func apply() {
        withAnimation(.easeInOut) {
            viewModel.applyFiltersAndSort(
                ibvnType: viewModel.ibvnType,
                seriesFilter: selectedSeriesFilter,
                podcastFilter: selectedFilter,
                sort: selectedSort
            )
        }
    }
    
    func listSection(_ searchResults: [CloudPlaylist]) -> some View {
        List {
            ForEach(searchResults, id: \.id) { playlist in
                NavigationLink(value: playlist) {
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
        viewModel.ibvnType == .podcast
        ? AnyView(podcastSegmentedControl)
        : AnyView(seriesSegmentedControl)
    }
    
    var seriesSegmentedControl: some View {
        Picker("Filtrar series", selection: $selectedSeriesFilter) {
            ForEach(SeriesFilterType.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    var podcastSegmentedControl: some View {
        Picker("Filtrar", selection: $selectedFilter) {
            ForEach(PodcastFilterType.allCases, id: \.self) {
                Text($0.rawValue)
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

enum PodcastFilterType: String, CaseIterable {
    case allPodcast = "Todas los Podcast"
    case erdh = "ERDH"
}
