//
//  CampusViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 1/5/24.
//

import Foundation
import FirebaseFirestore

final class CampusViewModel: ObservableObject, PresentAlertType {
    // MARK: Property Wrappers
    @Published var campus: [Campus] = []
    @Published var alertInfo: AlertInfo?
    
    // MARK: Properties
    var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init() {
        fetchCloudPlaylists()
    }
    
    // MARK: Functions
    func fetchCloudPlaylists() {
        let dataBase = Firestore.firestore()
        
        dataBase.collection("campus").getDocuments { [weak self] snapshot, error in
            guard let data = snapshot?.documents, error == nil else {
                self?.setupAlertInfo(AlertInfo(title: "Firebase Error",
                                               message: "No se ha logrado recuperar datos.",
                                               type: .error,
                                               leftButtonConfiguration: .okConfiguration))
                
                return
            }
            
            self?.campus = data.enumerated().map({ campus in
                return Campus(name: campus.element["name"] as? String ?? "",
                              address: campus.element["address"] as? String ?? "",
                              country: campus.element["country"] as? String ?? "",
                              latitude: campus.element["latitude"] as? Int ?? 0,
                              longitude: campus.element["longitude"] as? Int ?? 0,
                              pastor: campus.element["pastor"] as? String ?? "",
                              pastorImage: campus.element["pastorImage"] as? String ?? "",
                              phone: campus.element["phone"] as? String ?? "",
                              whatsapp: campus.element["whatsapp"] as? String ?? ""
                )
            })
        }
    }
    
    func setupAlertInfo(_ alert: AlertInfo) {
        presentAlert(alert)
    }
}
