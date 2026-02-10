//
//  ListVideosViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation
import Moya

final class ListVideosViewModel: ObservableObject, PresentAlertType {
    // MARK: Property Wrappers
    @Published var youtubePlaylist: YoutubePlaylist = .init()
    @Published var cloudPlaylist: CloudPlaylist
    @Published var showAlertDecodeError: Bool = false
    @Published var showRequestError: Bool = false
    @Published var alertInfo: AlertInfo?
    @Published var alertIsPresenting: Bool = false
    
    private var hasLoaded = false
    private var isLoading: Bool = false
    private var isLoaded = false
    
    // MARK: Variables
    var showPreview: Bool {
        cloudPlaylist.title.contains("#Preview") ||
        cloudPlaylist.description.contains("#Preview")
    }
    
    // MARK: Initialization
    init(playlist: CloudPlaylist) {
        self.cloudPlaylist = playlist

        NotificationCenter.default.addObserver(
            forName: .youtubeDataDidSync,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.forceReload()
        }

        loadIfNeeded()
    }
    
    // MARK: Functions
    func loadIfNeeded() {
        guard !isLoaded else {
            DLog("⏭️ YT LOAD SKIPPED → already loaded", cloudPlaylist.id)
            return
        }

        isLoaded = true

        if let cached =
            YoutubePlaylistCache.shared.get(
                for: cloudPlaylist.id,
                updatedAt: cloudPlaylist.updatedAt
            ) {

            youtubePlaylist = cached
            return
        }

        DLog("🌐 YT FETCH → playlist:", cloudPlaylist.id)
        fetchYoutubePlaylistItems()
    }
    
    private func fetchYoutubePlaylistItems(playlistId: String, pageToken: String = "") {
        youtubePlaylist = pageToken.isEmpty ? .init() : youtubePlaylist
        
        DLog("🌐 YT REQUEST → playlist:", playlistId, "pageToken:", pageToken)
        
        let provider = MoyaProvider<YoutubeApiManager>()
        
        provider.request(.playlistItems(playlistId: playlistId, pageToken: pageToken)) {[weak self] result in
            switch result {
            case let .success(response):
                do {
                    let youtubePlaylistPage = try JSONDecoder().decode(YoutubePlaylist.self, from: response.data)
                    _ = youtubePlaylistPage.items.map { [weak self] playlist in
                        self?.youtubePlaylist.items.append(
                            ListVideosItem(kind: playlist.kind, etag: playlist.etag, id: playlist.id, snippet: playlist.snippet)
                        )
                    }

                    guard let nextPageToken = youtubePlaylistPage.nextPageToken,
                          !nextPageToken.isEmpty else {

                        YoutubePlaylistCache.shared.set(
                            self?.youtubePlaylist ?? YoutubePlaylist(),
                            for: playlistId
                        )
                        
                        DLog("💾 YT CACHE SAVED → playlist:", playlistId,
                             "items:", self?.youtubePlaylist.items.count ?? 0)

                        return
                    }
                    
                    self?.fetchYoutubePlaylistItems(playlistId: playlistId, pageToken: nextPageToken)
                } catch {
                    self?.displayError(error)
                }
            case let .failure(error):
                self?.displayError(error)
            }
        }
    }
    
    func fetchYoutubePlaylistItems() {
        fetchYoutubePlaylistItems(playlistId: cloudPlaylist.id)
    }
    
    func forceReload() {
        isLoaded = false
        youtubePlaylist = .init()
        DLog("🔄 YT FORCE RELOAD → playlist:", cloudPlaylist.id)
    }
}
