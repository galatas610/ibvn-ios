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
    @Published var alertInfo: AlertInfo?
    @Published var cloudLive: CloudLive = .init()
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
        
        dataBase
            .collection("live")
            .document("lastLive")
            .addSnapshotListener { [weak self] snapshot, error in
                
                guard let data = snapshot?.data(), error == nil else {
                    self?.setupAlertInfo(
                        AlertInfo(
                            title: "Firebase Error",
                            message: "No se ha logrado recuperar datos.",
                            type: .error,
                            leftButtonConfiguration: .okConfiguration
                        )
                    )
                    
                    return
                }
                
                self?.cloudLive = CloudLive(
                    videoId: data["videoId"] as? String ?? "",
                    title: data["title"] as? String ?? "",
                    thumbnail: data["thumbnail"] as? String ?? "",
                    state: LiveState(rawValue: data["state"] as? String ?? "") ?? .last,
                    isLive: data["isLive"] as? Bool ?? false,
                    publishedAt: data["publishedAt"] as? String ?? "",
                    description: data["description"] as? String ?? ""
                )
                
                #if DEBUG
                    print("🔥 Live updated:", self?.cloudLive ?? .init())
                #endif
                
                self?.isLoading = false
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
