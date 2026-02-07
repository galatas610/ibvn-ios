//
//  RecommendedViewModel.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 2/3/26.
//

import Foundation
import FirebaseFirestore

final class RecommendedViewModel: ObservableObject {
    @Published var sundayPlaylists: [CloudPlaylist] = []
    @Published var ndvnPlaylists: [CloudPlaylist] = []
    @Published var pastSeriesPlaylists: [CloudPlaylist] = []

    private var allPlaylists: [CloudPlaylist] = []

    init() {
        fetchPlaylists()
    }

    private func fetchPlaylists() {
        let db = Firestore.firestore()

        db.collection("playlists").addSnapshotListener { [weak self] snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                DLog("🔥 Error fetching playlists")
                return
            }

            let playlists = documents.map {
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

            self?.allPlaylists = playlists
            self?.applyFilters()
        }
    }

    private func applyFilters() {
        sundayPlaylists = filterPlaylists(allPlaylists, for: .recommendedSunday)
        ndvnPlaylists = filterPlaylists(allPlaylists, for: .recommendedNDVN)
        pastSeriesPlaylists = filterPlaylists(allPlaylists, for: .recommended)

        DLog(
            "Recommended loaded",
            "Sunday:", sundayPlaylists.count,
            "NDVN:", ndvnPlaylists.count,
            "Past:", pastSeriesPlaylists.count
        )
    }

    private func filterPlaylists(
        _ playlists: [CloudPlaylist],
        for type: IbvnType
    ) -> [CloudPlaylist] {

        playlists.filter { playlist in
            let text = playlist.title + playlist.description

            let includeCheck: Bool = {
                guard !type.includeTags.isEmpty else { return true }
                return type.includeTags.contains { text.contains($0) }
            }()

            let excludeCheck: Bool = {
                guard !type.excludeTags.isEmpty else { return true }
                return !type.excludeTags.contains { text.contains($0) }
            }()

            return includeCheck && excludeCheck
        }
    }
}
