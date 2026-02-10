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
    
    private var isLoading: Bool = false
    private var accumulatedItems: [YoutubeVideo] = []
    private var isLoaded: Bool = false
    
    // MARK: Variables
    var showPreview: Bool {
        cloudPlaylist.title.contains("#Preview") ||
        cloudPlaylist.description.contains("#Preview")
    }
    
    // MARK: Initialization
    init(playlist: CloudPlaylist) {
        self.cloudPlaylist = playlist
        
        DLog("🧠 VM INIT →", cloudPlaylist.id)
        
        NotificationCenter.default.addObserver(
            forName: .youtubeDataDidSync,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.forceReload()
        }
    }
    
    // MARK: Functions
    func loadIfNeeded() {
        guard !isLoaded, !isLoading else {
            DLog("⏭️ YT LOAD SKIPPED → already loading/loaded", cloudPlaylist.id)
            return
        }
        
        // ✅ 1️⃣ CACHE FIRST
        if let cached = YoutubePlaylistCache.shared.get(
            for: cloudPlaylist.id,
            updatedAt: cloudPlaylist.updatedAt
        ) {
            youtubePlaylist = cached
            isLoaded = true
            DLog("📦 YT PLAYLIST LOADED FROM CACHE →", cloudPlaylist.id)
            return
        }
        
        // 🌐 2️⃣ FETCH
        isLoading = true
        youtubePlaylist = .init()
        
        fetchYoutubePlaylistItems(
            playlistId: cloudPlaylist.id,
            pageToken: nil
        )
    }
    
    private func fetchYoutubePlaylistItems(
        playlistId: String,
        pageToken: String? = nil
    ) {
        let token = pageToken ?? ""
        
        DLog("🌐 YT REQUEST → playlist:", playlistId, "pageToken:", token)
        
        let provider = MoyaProvider<YoutubeApiManager>()
        
        provider.request(.playlistItems(playlistId: playlistId, pageToken: token)) { [weak self] result in
            guard let self else { return }
            self.handlePlaylistResponse(
                result,
                playlistId: playlistId
            )
        }
    }
    
    private func handlePlaylistResponse(
        _ result: Result<Response, MoyaError>,
        playlistId: String
    ) {
        switch result {
        case let .success(response):
            handlePlaylistSuccess(response, playlistId: playlistId)
            
        case let .failure(error):
            isLoading = false
            displayError(error)
        }
    }
    
    private func handlePlaylistSuccess(
        _ response: Response,
        playlistId: String
    ) {
        do {
            let page = try JSONDecoder().decode(
                YoutubePlaylist.self,
                from: response.data
            )
            
            youtubePlaylist.items.append(contentsOf: page.items)
            
            if let next = page.nextPageToken, !next.isEmpty {
                fetchYoutubePlaylistItems(
                    playlistId: playlistId,
                    pageToken: next
                )
                return
            }
            
            YoutubePlaylistCache.shared.set(
                youtubePlaylist,
                for: playlistId
            )
            
            isLoaded = true
            isLoading = false
            
            DLog(
                "✅ YT FETCH COMPLETE → playlist:",
                playlistId,
                "items:",
                youtubePlaylist.items.count
            )
            
        } catch {
            isLoading = false
            displayError(error)
        }
    }
//    private func fetchYoutubePlaylistItems(
//        playlistId: String,
//        pageToken: String? = nil
//    ) {
//        let token = pageToken ?? ""
//        
//        DLog("🌐 YT REQUEST → playlist:", playlistId, "pageToken:", token)
//        
//        let provider = MoyaProvider<YoutubeApiManager>()
//        
//        provider.request(.playlistItems(playlistId: playlistId, pageToken: token)) { [weak self] result in
//            guard let self else { return }
//            
//            switch result {
//            case let .success(response):
//                do {
//                    let page = try JSONDecoder().decode(YoutubePlaylist.self, from: response.data)
//                    
//                    self.youtubePlaylist.items.append(contentsOf: page.items)
//                    
//                    if let next = page.nextPageToken, !next.isEmpty {
//                        // ✅ PAGINACIÓN REAL
//                        self.fetchYoutubePlaylistItems(
//                            playlistId: playlistId,
//                            pageToken: next
//                        )
//                        return
//                    }
//                    
//                    // ✅ FETCH COMPLETO
//                    YoutubePlaylistCache.shared.set(
//                        self.youtubePlaylist,
//                        for: playlistId
//                    )
//                    
//                    self.isLoaded = true
//                    self.isLoading = false
//                    
//                    DLog(
//                        "✅ YT FETCH COMPLETE → playlist:",
//                        playlistId,
//                        "items:",
//                        self.youtubePlaylist.items.count
//                    )
//                    
//                } catch {
//                    self.isLoading = false
//                    self.displayError(error)
//                }
//                
//            case let .failure(error):
//                self.isLoading = false
//                self.displayError(error)
//            }
//        }
//    }
    
    func fetchYoutubePlaylistItems() {
        fetchYoutubePlaylistItems(playlistId: cloudPlaylist.id)
    }
    
    func forceReload() {
        isLoaded = false
        isLoading = false
        youtubePlaylist = .init()
        
        DLog("🔄 YT FORCE RELOAD → playlist:", cloudPlaylist.id)
    }
}
