//
//  ListsViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation
import FirebaseFirestore

final class ListsViewModel: ObservableObject, PresentAlertType {
    // MARK: Property Wrappers
    @Published var visiblePlaylists: [CloudPlaylist] = []
    @Published var alertInfo: AlertInfo?
    
    // MARK: Properties
    private var allPlaylists: [CloudPlaylist] = []
    
    let ibvnType: IbvnType
    
    var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init(ibvnType: IbvnType) {
        self.ibvnType = ibvnType
        
        fetchCloudPlaylists()
    }
    
    // MARK: Functions
    func fetchCloudPlaylists() {
        let dataBase = Firestore.firestore()
        
        dataBase.collection("playlists").addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.documents, error == nil else {
                self?.setupAlertInfo(AlertInfo(title: "Firebase Error",
                                               message: "No se ha logrado recuperar datos.",
                                               type: .error,
                                               leftButtonConfiguration: .okConfiguration))
                
                return
            }
            
            self?.allPlaylists = data.map { document in
                CloudPlaylist(
                    id: document.documentID,
                    publishedAt: document["publishedAt"] as? String ?? "",
                    title: document["title"] as? String ?? "",
                    description: document["description"] as? String ?? "",
                    thumbnailUrl: document["thumbnailUrl"] as? String ?? "",
                    thumbnailWidth: document["thumbnailWidth"] as? Int ?? 0,
                    thumbnailHeight: document["thumbnailHeight"] as? Int ?? 0
                )
            }
            
            guard let self else { return }
            
            applyFiltersAndSort(
                ibvnType: ibvnType,
                seriesFilter: .allSeries,
                podcastFilter: .allPodcast,
                sort: .mostRecent
            )
        }
    }
    
    func applyFiltersAndSort(
        ibvnType: IbvnType,
        seriesFilter: SeriesFilterType,
        podcastFilter: PodcastFilterType,
        sort: PlaylistSortType
    ) {
        var result = filterPlaylists(allPlaylists, for: ibvnType)
        
        // Filtro secundario
        if ibvnType == .podcast {
            switch podcastFilter {
            case .allPodcast:
                break
            case .erdh:
                result = result.filter {
                    ($0.title + $0.description).contains(IbvnType.elRetoDeHoy.includeTags.first ?? "")
                }
            }
        } else {
            switch seriesFilter {
            case .allSeries:
                break
            case .ndvn:
                result = result.filter {
                    ($0.title + $0.description).contains(IbvnType.nocheDeViernes.includeTags.first ?? "")
                }
            }
        }
        
        // Sort FINAL
        visiblePlaylists = sortPlaylists(result, by: sort)
        
        DLog("applyFiltersAndSort → count:", visiblePlaylists.count)
    }
    
    func setupAlertInfo(_ alert: AlertInfo) {
        presentAlert(alert)
    }
    
    func filterPlaylists(
        _ playlists: [CloudPlaylist],
        for type: IbvnType
    ) -> [CloudPlaylist] {
        
        playlists.filter { playlist in
            let text = (playlist.title + playlist.description)
            
            // INCLUDE
            let includeCheck: Bool = {
                guard !type.includeTags.isEmpty else { return true }
                return type.includeTags.contains { text.contains($0) }
            }()
            
            // EXCLUDE
            let excludeCheck: Bool = {
                guard !type.excludeTags.isEmpty else { return true }
                return !type.excludeTags.contains { text.contains($0) }
            }()
            
            return includeCheck && excludeCheck
        }
    }
    
    func sortPlaylists(
        _ playlists: [CloudPlaylist],
        by sortType: PlaylistSortType
    ) -> [CloudPlaylist] {
        
        switch sortType {
        case .mostRecent:
            return playlists.sorted {
                $0.publishedDate > $1.publishedDate
            }
            
        case .alphabetical:
            return playlists.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }
    }
}
