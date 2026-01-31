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
    @Published var youtubeVideo: YoutubeVideo = .init()
    @Published var alertInfo: AlertInfo?
    @Published var cloudLive: [CloudLive] = .init()
    @Published var isLoading = true
    
    // MARK: Propertes
    let ibvnType: IbvnType
    
    var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init(ibvnType: IbvnType) {
        self.ibvnType = ibvnType
       
        fetchCloudLive()
    }
    
    // MARK: Functions
    func fetchCloudLive() {
        isLoading = true
        
        let dataBase = Firestore.firestore()
        
        dataBase.collection("live").addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.documents, error == nil else {
                self?.setupAlertInfo(AlertInfo(title: "Firebase Error",
                                               message: "No se ha logrado recuperar datos.",
                                               type: .error,
                                               leftButtonConfiguration: .okConfiguration))
                
                return
            }
            
            self?.cloudLive = data.map { CloudLive(videoId: $0["videoId"] as? String ?? "") }
            
            self?.taskFetchYoutubeVideoById(self?.cloudLive.first?.videoId ?? "")
            
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
            
            let decoded = try JSONDecoder().decode(YoutubeVideo.self, from: data)
            
            await MainActor.run {
                self.youtubeVideo = decoded
                
                isLoading = false
            }
            
        } catch let error as NSError {
            print("🚩 error: \(error)")
        }
    }
    
    func setupAlertInfo(_ alert: AlertInfo) {
        presentAlert(alert)
    }
    
    func openWhatsApp(phone: String, message: String) {
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://wa.me/\(phone)?text=\(encodedMessage)"

        if let url = URL(string: urlString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
