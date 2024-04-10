//
//  LiveViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation
import FirebaseFirestore

class LiveViewModel: ObservableObject, PresentAlertType {
    // MARK: Property Wrappers
    @Published var youtubeVideo: Video = .init()
    @Published var alertInfo: AlertInfo?
    @Published var live: [LiveCloud] = .init()
    
    // MARK: Propertes
    var alertIsPresenting: Bool = false
    
    let ibvnType: IbvnType
    
    // MARK: Initialization
    init(ibvnType: IbvnType) {
        self.ibvnType = ibvnType
       
        fetchCloudLive()
    }
    
    // MARK: Functions
    func fetchCloudLive() {
        let dataBase = Firestore.firestore()
        
        dataBase.collection("live").addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.documents, error == nil else {
                self?.setupAlertInfo(AlertInfo(title: "Firebase Error",
                                               message: "No se ha logrado recuperar datos.",
                                               type: .error,
                                               leftButtonConfiguration: .okConfiguration))
                
                return
            }
            
            self?.live = data.map { LiveCloud(videoId: $0["videoId"] as? String ?? "") }
            
            self?.taskFetchYoutubeVideoById(self?.live.first?.videoId ?? "")
            
        }
    }
    
    func taskFetchYoutubeVideoById(_ videoId: String) {
        Task {
            await fetchYoutubeVideoById(videoId)
        }
    }
    
    private func fetchYoutubeVideoById(_ videoId: String) async {
        let playlistUrl = "https://www.googleapis.com/youtube/v3/videos"
        guard let url = URL(string: playlistUrl + "?key=AIzaSyCTkfyhNMgKcDTlZsNZ2IT57ztfXySdl5c&channelId=UCoNq7HF7vnqalfg-lTaxrDQ&id=" + videoId + "&part=snippet") else {
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
                    self.youtubeVideo = try JSONDecoder().decode(Video.self, from: data)
                } catch let error as NSError {
                    print("🚩 error: \(error)")
                }
            }
        } catch let error as NSError {
            print("🚩 error: \(error)")
        }
    }
    
    func setupAlertInfo(_ alert: AlertInfo) {
        presentAlert(alert)
    }
}
