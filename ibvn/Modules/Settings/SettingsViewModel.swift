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
    
    // MARK: Properties
    var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init() { }
    
    // MARK: Functions
    func syncLive(eventType: String = "upcoming") {
        viewMessage = eventType == "upcoming" ? "" : viewMessage
        
        let provider = MoyaProvider<YoutubeApiManager>()
        
        provider.request(.live(eventType: eventType)) { result in
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
