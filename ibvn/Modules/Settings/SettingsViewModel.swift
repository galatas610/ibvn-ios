//
//  SettingsViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 10/4/24.
//

import Foundation
import FirebaseFirestore
import Moya

final class SettingsViewModel: ObservableObject, PresentAlertType {
    // MARK: - Published
    @Published var youtubeLive: YoutubeLive = .init()
    @Published var viewMessage: String = ""
    @Published var alertInfo: AlertInfo?
    @Published var youtubePlaylists: YoutubePlaylists = .init()
    @Published var cloudPlaylists: [CloudPlaylist] = []
    
    // MARK: - Properties
    private var isSyncingPlaylists = false
    private var tempPlaylists: [CloudPlaylist] = []
    
    let provider = MoyaProvider<YoutubeApiManager>()
    
    var alertIsPresenting: Bool = false
    
    // MARK: - Init
    init() {}
    
    // MARK: - Sync Playlists
    func syncPlaylist(pageToken: String = "") {
        // 🔒 Evita reentradas
        if pageToken.isEmpty {
            guard !isSyncingPlaylists else { return }
            isSyncingPlaylists = true
            tempPlaylists = []
            viewMessage = "🔄 Iniciando sincronización..."
        }

        provider.request(.playlist(pageToken: pageToken)) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                self.handlePlaylistSuccess(response, pageToken: pageToken)

            case .failure(let error):
                self.isSyncingPlaylists = false
                self.displayError(error)
            }
        }
    }
    
    // MARK: - Playlist Handlers
    private func handlePlaylistSuccess(_ response: Response, pageToken: String) {
        do {
            let decoded = try JSONDecoder().decode(YoutubePlaylists.self, from: response.data)

            // ⚠️ NO publiques nada aquí
            appendPlaylists(decoded.items)

            handleNextPage(decoded.nextPageToken)
        } catch {
            isSyncingPlaylists = false
            displayError(error)
        }
    }
    
    private func appendPlaylists(_ items: [ItemResponse]) {
        items
            .map(makeCloudPlaylist)
            .forEach { tempPlaylists.append($0) }
    }
    
    private func makeCloudPlaylist(from item: ItemResponse) -> CloudPlaylist {
        let thumbnails = item.snippet.thumbnails
        
        return CloudPlaylist(
            id: item.id,
            publishedAt: item.snippet.publishedAt,
            title: item.snippet.title,
            description: item.snippet.description,
            thumbnailUrl: resolveThumbnailURL(from: thumbnails) ?? "",
            thumbnailWidth: thumbnails.high?.width ?? 0,
            thumbnailHeight: thumbnails.high?.height ?? 0,
            updatedAt: TimeInterval(
                abs(item.etag.hashValue)
            )
        )
    }
    
    private func resolveThumbnailURL(from thumbnails: ThumbnailsResponse) -> String? {
        return thumbnails.maxres?.url
        ?? thumbnails.standard?.url
        ?? thumbnails.high?.url
        ?? thumbnails.medium?.url
        ?? thumbnails.default?.url
    }
    
    private func handleNextPage(_ token: String?) {
        guard let token, !token.isEmpty else {
            finalizePlaylistSync()
            
            return
        }
        
        syncPlaylist(pageToken: token)
    }
    
    private func finalizePlaylistSync() {
        isSyncingPlaylists = false

        cloudPlaylists = tempPlaylists
        viewMessage = "✅ \(cloudPlaylists.count) Listas descargadas."

        // 🔥 1️⃣ Invalidar cache SOLO cuando ya hay data nueva
        YoutubePlaylistCache.shared.invalidateAll()

        // 🔔 2️⃣ Avisar a todos los ViewModels
        NotificationCenter.default.post(
            name: .youtubeDataDidSync,
            object: nil
        )

        // ☁️ 3️⃣ Subir a Firebase
        saveListsOnCloud(cloudPlaylist: cloudPlaylists)
    }
    
    private func updateProgressMessage() {
        viewMessage += "\n🔄 \(cloudPlaylists.count) Listas descargadas."
    }
    
    private func resetStateIfNeeded(_ pageToken: String) {
        if pageToken.isEmpty {
            viewMessage = ""
            cloudPlaylists = []
        }
    }
    
    // MARK: - Sync Live
    func syncLive(eventType: String = "upcoming") {
        if eventType == "upcoming" { viewMessage = "" }
        
        provider.request(.search(eventType: eventType)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.handleLiveSuccess(response, eventType: eventType)
                
            case .failure(let error):
                self.displayError(error)
            }
        }
    }
    
    private func handleLiveSuccess(_ response: Response, eventType: String) {
        do {
            youtubeLive = try JSONDecoder().decode(YoutubeLive.self, from: response.data)
            
            guard let item = youtubeLive.items.first else {
                handleNextLiveState(eventType)
                return
            }
            
            let cloudLive = CloudLive(
                videoId: item.id.videoId,
                title: item.snippet.title,
                thumbnail: item.snippet.thumbnails.high.url,
                state: {
                    switch item.snippet.liveBroadcastContent {
                    case "live": return .live
                    case "upcoming": return .upcoming
                    default: return .last
                    }
                }(),
                isLive: item.snippet.liveBroadcastContent == "live",
                publishedAt: item.snippet.publishedAt,
                description: item.snippet.description
            )
            
            viewMessage += "\n ✅ \(cloudLive.state) disponible."
            saveLiveOnCloud(cloudLive)
            
        } catch {
            displayError(error)
        }
    }
    
    private func handleNextLiveState(_ eventType: String) {
        viewMessage += "\n 🚫 \(eventType) no disponible."
        
        switch eventType {
        case "upcoming": syncLive(eventType: "live")
        case "live": syncLive(eventType: "completed")
        default: break
        }
    }
    
    // MARK: - Firestore
    private func saveListsOnCloud(cloudPlaylist: [CloudPlaylist]) {
        viewMessage += "\n⬆️ Subiendo \(cloudPlaylist.count) Listas a la nube."

        let remoteDataBase = Firestore.firestore()
        let batch = remoteDataBase.batch()

        cloudPlaylist.forEach {
            let ref = remoteDataBase.collection("playlists").document($0.id)
            batch.setData($0.asDictionary(), forDocument: ref)
        }

        batch.commit { [weak self] error in
            if error == nil {
                self?.viewMessage += "\n🆗 \(cloudPlaylist.count) Listas en la nube"
            }
        }
    }
    
    private func saveLiveOnCloud(_ cloudLive: CloudLive) {
        let remoteDataBase = Firestore.firestore()
        
        remoteDataBase.collection("live")
            .document("lastLive")
            .setData(cloudLive.asDictionary()) { [weak self] error in
                if error == nil {
                    self?.viewMessage += "\n🆗 En vivo en la nube"
                }
            }
    }
}
