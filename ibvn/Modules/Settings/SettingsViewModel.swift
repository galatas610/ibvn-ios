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
    @Published var youtubeLive: YoutubeLive = .init()
    @Published var viewMessage: String = ""
    @Published var alertInfo: AlertInfo?
    @Published var youtubePlaylists: YoutubePlaylists = .init()
    @Published var cloudPlaylists: [CloudPlaylist] = .init()
    
    // MARK: Properties
    let provider = MoyaProvider<YoutubeApiManager>()
    
    var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init() { }
    
    // MARK: Functions
    func syncPlaylist(pageToken: String = "") {
        viewMessage = pageToken.isEmpty ? "" : viewMessage
        cloudPlaylists = pageToken.isEmpty ? .init() : cloudPlaylists
        
        provider.request(.playlist(pageToken: pageToken)) {[weak self] result in
            switch result {
            case let .success(response):
                do {
                    self?.youtubePlaylists = try JSONDecoder().decode(YoutubePlaylists.self, from: response.data)
                    _ = self?.youtubePlaylists.items.map { [weak self] playlist in
                        self?.cloudPlaylists.append(CloudPlaylist(id: playlist.id,
                                                                  publishedAt: playlist.snippet.publishedAt,
                                                                  title: playlist.snippet.title,
                                                                  description: playlist.snippet.description,
                                                                  thumbnailUrl: playlist.snippet.thumbnails.medium.url,
                                                                  thumbnailWidth: playlist.snippet.thumbnails.high.width,
                                                                  thumbnailHeight: playlist.snippet.thumbnails.high.height)
                        )
                    }
                    self?.viewMessage += "\n🔄 \(self?.cloudPlaylists.count ?? 0) Listas descargadas."
                    
                    guard let nextPageToken = self?.youtubePlaylists.nextPageToken, !nextPageToken.isEmpty else {
                        self?.viewMessage += "\n✅ \(self?.cloudPlaylists.count ?? 0) Listas descargadas en total."
                        
                        self?.saveListsOnCloud(cloudPlaylist: self?.cloudPlaylists ?? [])
                        
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
                    self.youtubeLive = try JSONDecoder().decode(YoutubeLive.self, from: response.data)
                    
                    if self.youtubeLive.items.isEmpty {
                        self.viewMessage += "\n 🚫 \(eventType), no disponible."
                        if eventType == "upcoming" {
                            self.syncLive(eventType: "live")
                        } else if eventType == "live" {
                            self.syncLive(eventType: "completed")
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
    
    private func saveListsOnCloud(cloudPlaylist: [CloudPlaylist]) {
        viewMessage += "\n⬆️ Subiendo \(cloudPlaylist.count) Listas a la nube."
        
        let dataBase = Firestore.firestore()
        
        for playlist in cloudPlaylist {
            dataBase.collection("playlists")
                .document(playlist.id)
                .setData(playlist.asDictionary()) { [weak self] error in
                    guard error == nil else {
                        self?.displayError(error)
                        
                        return
                    }
                }
        }
        
        viewMessage += "\n🆗 \(cloudPlaylist.count) Listas en la Nube"
    }
    
    private func saveLiveOnCloud(liveVideoId: String) {
        let liveCloud = CloudLive(videoId: liveVideoId)
        
        let dataBase = Firestore.firestore()
        
        dataBase.collection("live")
            .document("lastLive")
            .setData(liveCloud.asDictionary()) { [weak self] error in
                guard error == nil else {
                    self?.displayError(error)
                    
                    return
                }
                
                self?.viewMessage += "\n 🆗 En vivo en la nube"
            }
        
    }
}
