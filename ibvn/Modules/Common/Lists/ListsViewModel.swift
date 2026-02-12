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
    private var playlistsListener: ListenerRegistration?
    
    let ibvnType: IbvnType
    
    var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init(ibvnType: IbvnType) {
        self.ibvnType = ibvnType
        
        fetchCloudPlaylists()
    }
    
    // MARK: Functions
    func fetchCloudPlaylists() {
        playlistsListener?.remove()
        
        let dataBase = Firestore.firestore()
        
        playlistsListener = dataBase
            .collection("playlists")
            .addSnapshotListener { [weak self] snapshot, error in
                
                guard let self,
                      let data = snapshot?.documents,
                      error == nil else {
                    self?.setupAlertInfo(
                        AlertInfo(
                            title: "Firebase Error",
                            message: "No se ha logrado recuperar datos.",
                            type: .error,
                            leftButtonConfiguration: .okConfiguration
                        )
                    )
                    return
                }
                
                let newPlaylists = newPlaylistsMap(data)
                
                guard newPlaylists != self.allPlaylists else { return }
                
                self.allPlaylists = newPlaylists
                
                self.applyFiltersAndSort(
                    ibvnType: self.ibvnType,
                    seriesFilter: .allSeries,
                    podcastFilter: .allPodcast,
                    sort: .mostRecent
                )
            }
    }
    
    private func newPlaylistsMap(_ data: [QueryDocumentSnapshot]) -> [CloudPlaylist] {
        data.map {
            CloudPlaylist(
                id: $0.documentID,
                publishedAt: $0["publishedAt"] as? String ?? "",
                title: $0["title"] as? String ?? "",
                description: $0["description"] as? String ?? "",
                thumbnailUrl: $0["thumbnailUrl"] as? String ?? "",
                thumbnailWidth: $0["thumbnailWidth"] as? Int ?? 0,
                thumbnailHeight: $0["thumbnailHeight"] as? Int ?? 0
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
            // Normaliza el texto de la playlist
            let text = (playlist.title + playlist.description)
            let normText = text.folding(options: .diacriticInsensitive, locale: .current).lowercased()
            
            // Pre-normaliza los tags de include/exclude
            let includeTags = type.includeTags.map {
                $0.folding(options: .diacriticInsensitive, locale: .current).lowercased()
            }
            let excludeTags = type.excludeTags.map {
                $0.folding(options: .diacriticInsensitive, locale: .current).lowercased()
            }

            // INCLUDE
            let includeCheck: Bool = {
                guard !includeTags.isEmpty else { return true }
                return includeTags.contains { normText.contains($0) }
            }()

            // EXCLUDE
            let excludeCheck: Bool = {
                guard !excludeTags.isEmpty else { return true }
                return !excludeTags.contains { normText.contains($0) }
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
