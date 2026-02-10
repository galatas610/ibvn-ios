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
    let provider = MoyaProvider<YoutubeApiManager>()
    var alertIsPresenting: Bool = false
    
    // MARK: - Init
    init() {}
    
    // MARK: - Sync Playlists
    func syncPlaylist(pageToken: String = "") {
        resetStateIfNeeded(pageToken)
        
        provider.request(.playlist(pageToken: pageToken)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.handlePlaylistSuccess(response, pageToken: pageToken)
                
            case .failure(let error):
                self.displayError(error)
            }
        }
    }
    
    // MARK: - Playlist Handlers
    private func handlePlaylistSuccess(_ response: Response, pageToken: String) {
        do {
            let decoded = try JSONDecoder().decode(YoutubePlaylists.self, from: response.data)
            
            youtubePlaylists = decoded
            
            appendPlaylists(decoded.items)
            updateProgressMessage()
            handleNextPage(decoded.nextPageToken)
        } catch {
            displayError(error)
        }
    }
    
    private func appendPlaylists(_ items: [ItemResponse]) {
        items
            .map(makeCloudPlaylist)
            .forEach { cloudPlaylists.append($0) }
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
            thumbnailHeight: thumbnails.high?.height ?? 0
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
        viewMessage += "\n✅ \(cloudPlaylists.count) Listas descargadas en total."
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
                    case "live": return "live"
                    case "upcoming": return "upcoming"
                    default: return "last"
                    }
                }(),
                isLive: item.snippet.liveBroadcastContent == "live",
                publishedAt: item.snippet.publishedAt
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
        cloudPlaylist.forEach {
            remoteDataBase.collection("playlists")
                .document($0.id)
                .setData($0.asDictionary())
        }
        
        viewMessage += "\n🆗 \(cloudPlaylist.count) Listas en la Nube"
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
