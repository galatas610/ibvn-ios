//
//  SettingsViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 10/4/24.
//

import Foundation
import FirebaseFirestore

class SettingsViewModel: ObservableObject, PresentAlertType {
    // MARK: Property Wrappers
    @Published var youtubeLive: Live = .init()
    @Published var viewMessage: String = ""
    @Published var alertInfo: AlertInfo?
    
    // MARK: Properties
    var alertIsPresenting: Bool = false
    
    // MARK:  Initialization
    init() { }
    
    // MARK: Functions
    func syncLive() {
        viewMessage = ""
        Task {
            await fetchYoutubeUpcoming()
        }
    }
    
    private func fetchYoutubeUpcoming() async {
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyDxL4ZavnYUE0_cMWOVt_ibWoPqcfMfLSQ&channelId=UCoNq7HF7vnqalfg-lTaxrDQ&type=video&order=date&part=snippet&maxResults=10&eventType=upcoming") else {
            print("🚩 Fail ElRetoDeHoy playlistVideos URL")
            
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard  let httpResponse = response as? HTTPURLResponse else {
                print("🚩 httpResponse: \(String(describing: response))")
                print("🚩 error Response: \(String(describing: response.description))")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("🚩 fail httpResponde StatusCode: \(httpResponse.statusCode)")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    self.youtubeLive = try JSONDecoder().decode(Live.self, from: data)
                    print("🚶 search Upcoming: ", self.youtubeLive)
                    
                    if self.youtubeLive.items.isEmpty {
                        self.viewMessage += " 🚫 Próximo en vivo no disponible."
                        self.taskFetchYoutubeLive()
                    } else {
                        self.viewMessage += "\n ✅ Próximo en vivo disponible."
                       
                        if let newLive = self.youtubeLive.items.first?.id.videoId {
                            self.viewMessage += "\n ⬆️ Subiendo en vivo a la nube."
                            
                            self.saveCloudLiveVideoId(liveVideoId: newLive)
                        } else {
                            self.viewMessage += "\n 🚫 No en vivo id disponible."
                        }
                    }
                } catch let error as NSError {
                    print("🚩 error: \(error)")
                }
            }
        } catch let error as NSError {
            print("🚩 error: \(error)")
        }
    }
    
    private func taskFetchYoutubeLive() {
        Task {
            await fetchYoutubeLive()
        }
    }
    
    private func fetchYoutubeLive() async {
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyDxL4ZavnYUE0_cMWOVt_ibWoPqcfMfLSQ&channelId=UCoNq7HF7vnqalfg-lTaxrDQ&type=video&order=date&part=snippet&maxResults=10&eventType=live") else {
            print("🚩 Fail ElRetoDeHoy playlistVideos URL")
            
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard  let httpResponse = response as? HTTPURLResponse else {
                print("🚩 httpResponse: \(String(describing: response))")
                print("🚩 error Response: \(String(describing: response.description))")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("🚩 fail httpResponde StatusCode: \(httpResponse.statusCode)")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    self.youtubeLive = try JSONDecoder().decode(Live.self, from: data)
                    print("🚶 search live: ", self.youtubeLive)
                    
                    if self.youtubeLive.items.isEmpty {
                        self.viewMessage += "\n 🚫 En vivo no disponible."
                        // TODO: Eliminar after Debug
                        self.viewMessage += "\n ⬆️ Subiendo en vivo de prueba a la nube."
                        self.saveCloudLiveVideoId(liveVideoId: self.youtubeLive.items.first?.id.videoId ?? "Fw_Xla9ItH8")
                    } else {
                        self.viewMessage += "\n ✅ En vivo disponible."
                        
                        if let newLive = self.youtubeLive.items.first?.id.videoId {
                            self.viewMessage += "\n ⬆️ Subiendo en vivo a la nube."
                            
                            self.saveCloudLiveVideoId(liveVideoId: newLive)
                        } else {
                            self.viewMessage += "\n 🚫 No en vivo id disponible."
                        }
                    }
                } catch let error as NSError {
                    print("🚩 error: \(error)")
                }
            }
        } catch let error as NSError {
            print("🚩 error: \(error)")
        }
    }
    
    private func saveCloudLiveVideoId(liveVideoId: String) {
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

// MARK: - Alert
extension SettingsViewModel {
    func setupAlertInfo(_ alert: AlertInfo) {
        presentAlert(alert)
    }
    
    private func displayError(_ error: Error?) {
        let configuration = ButtonConfiguration(
            title: "Entendido",
            buttonAction: {}
        )
                
        guard let errorMessage = error?.localizedDescription else {
            return
        }
        
        alertInfo = AlertInfo(
            title: "Alerta",
            message: errorMessage,
            type: .error,
            leftButtonConfiguration: configuration
        )
        
        presentAlert(alertInfo)
    }
}
