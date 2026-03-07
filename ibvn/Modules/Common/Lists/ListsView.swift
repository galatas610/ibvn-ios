//
//  ListsView.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import SwiftUI

struct ListsView: View {
    @StateObject private var viewModel: ListsViewModel
    @State private var searchText = ""
    @State private var selectedSort: PlaylistSortType = .mostRecent
    @State private var selectedSeriesFilter: SeriesFilterType = .allSeries
    @State private var selectedFilter: PodcastFilterType = .allPodcast
    @FocusState private var isKeyboardFocused: Bool

    init(viewModel: ListsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            content
            listSection(searchResults)
        }
        .background(Constants.fondoOscuro)
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("IbvnLogo")
                    .resizable()
                    .frame(width: 120, height: 31)
            }

            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    isKeyboardFocused = false
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
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

    @ViewBuilder
    var content: some View {
        title

        searchBar
            .padding(.bottom, 8)

        sortSegmentedControl
        seriesFilterSegmentedControl
    }

    var title: some View {
        HStack {
            Text(viewModel.ibvnType.viewTitle)
                .appFont(.dmSans, .black, size: 32).tracking(-2)
                .padding(.leading)
                .padding(.bottom, 8)

            Spacer()
        }
    }

    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Constants.textoPrincipal)

            KeyboardSearchField(text: $searchText, placeholder: "Buscar")
                .frame(height: 20)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Constants.textoPrincipal)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Constants.acentoVerde)
        )
        .padding(.horizontal)
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
                    .appFont(.dmSans, .semiBold, size: 16)
                    .foregroundColor(.white)

                Text(item.publishedAt.formatDate())
                    .appFont(.dmSans, .regular, size: 12)
                    .foregroundColor(.white)
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
    case allPodcast = "Todos los Podcast"
    case erdh = "ERDH"
}
