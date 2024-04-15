//
//  SettingsViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 10/4/24.
//

import Foundation
import FirebaseFirestore
import Moya

class SettingsViewModel: ObservableObject, PresentAlertType {
    // MARK: Property Wrappers
    @Published var youtubeLive: Live = .init()
    @Published var viewMessage: String = ""
    @Published var alertInfo: AlertInfo?
    @Published var playlistResponse: PlaylistResponse = .init()
    @Published var playlistCloud: [PlaylistCloud] = .init()
    
    // MARK: Properties
    let provider = MoyaProvider<YoutubeApiManager>()
    
    var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init() { }
    
    // MARK: Functions
    func syncPlaylist(pageToken: String = "") {
        viewMessage = pageToken.isEmpty ? "" : viewMessage
        playlistCloud = pageToken.isEmpty ? .init() : playlistCloud
        
        provider.request(.playlist(pageToken: pageToken)) {[weak self] result in
            switch result {
            case let .success(response):
                do {
                    self?.playlistResponse = try JSONDecoder().decode(PlaylistResponse.self, from: response.data)
                    _ = self?.playlistResponse.items.map { [weak self] playlist in
                        self?.playlistCloud.append(PlaylistCloud(id: playlist.id,
                                                                snippet: SnippetCloud(
                                                                    publishedAt: playlist.snippet.publishedAt,
                                                                    title: playlist.snippet.title,
                                                                    description: playlist.snippet.description,
                                                                    thumbnailUrl: playlist.snippet.thumbnails.medium.url,
                                                                    thumbnailWidth: playlist.snippet.thumbnails.high.width,
                                                                    thumbnailHeight: playlist.snippet.thumbnails.high.height
                                                                )
                                                               )
                        )
                    }
                    self?.viewMessage += "\n🔄 \(self?.playlistCloud.count ?? 0) Listas descargadas."
                    
                    guard let nextPageToken = self?.playlistResponse.nextPageToken, !nextPageToken.isEmpty else {
                        self?.viewMessage += "\n✅ \(self?.playlistCloud.count ?? 0) Listas descargadas en total."
                        
                        return
                    }
                    
                    self?.syncPlaylist(pageToken: nextPageToken)
                } catch {
                    self?.displayError(error)
                }
            case let .failure(error):
                self?.displayError(error)
            }
        }
    }
    
    // MARK: Sync Live
    func syncLive(eventType: String = "upcoming") {
        viewMessage = eventType == "upcoming" ? "" : viewMessage
        
        provider.request(.search(eventType: eventType)) { result in
            switch result {
            case let .success(response):
                do {
                    self.youtubeLive = try JSONDecoder().decode(Live.self, from: response.data)
                    
                    if self.youtubeLive.items.isEmpty {
                        self.viewMessage += "\n 🚫 \(eventType), no disponible."
                        if eventType == "upcoming" {
                            self.syncLive(eventType: "live")
                        }
                    } else {
                        self.viewMessage += "\n ✅ \(eventType) en vivo, disponible."
                       
                        if let newLive = self.youtubeLive.items.first?.id.videoId {
                            self.viewMessage += "\n ⬆️ Subiendo \(eventType) a la nube."
                            
                            self.saveLiveOnCloud(liveVideoId: newLive)
                        } else {
                            self.viewMessage += "\n 🚫 No disponible, \(eventType) id."
                        }
                    }
                } catch {
                    self.displayError(error)
                }
            case let .failure(error):
                self.displayError(error)
            }
        }
    }
    
    private func saveLiveOnCloud(liveVideoId: String) {
        let liveCloud = LiveCloud(videoId: liveVideoId)
        
        let dataBase = Firestore.firestore()
        
        dataBase.collection("live")
            .document("lastLive")
            .setData(liveCloud.asDictionary()) { [weak self] error in
                guard error == nil else {
                    self?.displayError(error)
                    
                    return
                }
                
                self?.viewMessage += "\n ✅ En vivo en la nube"
            }
    }
}
