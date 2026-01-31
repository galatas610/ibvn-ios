//
//  ListsViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation
import FirebaseFirestore

final class ListsViewModel: ObservableObject, PresentAlertType {
   // MARK: Property Wrappers
    @Published var cloudPlaylists: [CloudPlaylist] = []
    @Published var alertInfo: AlertInfo?
    
    // MARK: Properties
    let ibvnType: IbvnType
    
    var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init(ibvnType: IbvnType) {
        self.ibvnType = ibvnType
       
        fetchCloudPlaylists()
    }
    
    // MARK: Functions
    func fetchCloudPlaylists() {
        let dataBase = Firestore.firestore()
        
        dataBase.collection("playlists").addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.documents, error == nil else {
                self?.setupAlertInfo(AlertInfo(title: "Firebase Error",
                                               message: "No se ha logrado recuperar datos.",
                                               type: .error,
                                               leftButtonConfiguration: .okConfiguration))
                
                return
            }
            
            self?.cloudPlaylists = data.enumerated().map({ playlist in
                return CloudPlaylist(
                    id: playlist.element["id"] as? String ?? "",
                    publishedAt: playlist.element["publishedAt"] as? String ?? "",
                    title: playlist.element["title"] as? String ?? "",
                    description: playlist.element["description"] as? String ?? "",
                    thumbnailUrl: playlist.element["thumbnailUrl"] as? String ?? "",
                    thumbnailWidth: playlist.element["thumbnailWidth"] as? Int ?? 0,
                    thumbnailHeight: playlist.element["thumbnailHeight"] as? Int ?? 0
                )
            })
            
//            guard
//                self?.ibvnType == .podcast ||
//                self?.ibvnType == .recommended
//            else {
//                return
//            }
            
            switch self?.ibvnType {
// /           case .series:
            case .podcast:
                
                self?.cloudPlaylists = self?.cloudPlaylists.filter({ playlist in
                    playlist.title.contains(IbvnType.podcast.hashTag) ||
                    playlist.description.contains(IbvnType.podcast.hashTag) ||
                    playlist.title.contains(IbvnType.elRetoDeHoy.hashTag) ||
                    playlist.description.contains(IbvnType.elRetoDeHoy.hashTag)
                }) ?? []
//            case .recommended:
            
            default: break
            }
            
//            self?.cloudPlaylists = self?.cloudPlaylists.filter({ playlist in
//                playlist.title.contains(self?.ibvnType.hashTag ?? "") ||
//                playlist.description.contains(self?.ibvnType.hashTag ?? "")
//            }) ?? []
        }
    }
    
    func setupAlertInfo(_ alert: AlertInfo) {
        presentAlert(alert)
    }
}
