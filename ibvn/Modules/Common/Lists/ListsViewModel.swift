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
        
            visiblePlaylists = filterPlaylists(allPlaylists, for: ibvnType)
            
            visiblePlaylists = sortPlaylists(visiblePlaylists, by: .mostRecent)
        }
    }
    
    func sortVisibleListAlphabetical() {
        visiblePlaylists = sortPlaylists(visiblePlaylists, by: .alphabetical)
        
        DLog("sortVisibleListAlphabetical → count:", visiblePlaylists.count)
    }
    
    func sortVisibleListByMostRecent() {
        visiblePlaylists = sortPlaylists(visiblePlaylists, by: .mostRecent)
        
        DLog("sortVisibleListByMostRecent → count:", visiblePlaylists.count)
    }
    
    func showNDVNLists() {
        visiblePlaylists = filterPlaylists(allPlaylists, for: .nocheDeViernes)
        
        DLog("showNDVNLists → count:", visiblePlaylists.count)
    }
    
    func showRetoDeHoyLists() {
        visiblePlaylists = filterPlaylists(allPlaylists, for: .elRetoDeHoy)
        
        DLog("showRetoDeHoyLists → count:", visiblePlaylists.count)
    }
    
    func showPodcastAndRetoLists() {
        visiblePlaylists = allPlaylists.filter { playlist in
            let text = playlist.title + playlist.description
            return text.contains("#Podcast") || text.contains("#ElRetoDeHoy")
        }

        DLog("showPodcastAndRetoLists → count:", visiblePlaylists.count)
    }
    
    func showAllSeries() {
        visiblePlaylists = filterPlaylists(allPlaylists, for: .series)
        
        DLog("Series count:", visiblePlaylists.count)
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
