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
    @Published var campus: [Campus]? = []
    @Published var alertInfo: AlertInfo?
    @Published var campusLocations: [CampusLocation] = []
    
    // MARK: Properties
    var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init() {
        fetchCloudPlaylists()
        fillPinnedCampus()
    }
    
    // MARK: Functions
    func fillPinnedCampus() {
        campusLocations = [CampusLocation(latitude: 13.674692, longitude: -89.227735)]
    }
    
    func moveToPreviousCampus(currentCampus: Campus) -> Campus {
        let index = campus?.firstIndex(of: currentCampus) ?? .init()
        
        guard index != 0 else {
            return campus?.last ?? .init()
        }
        
        return campus?[index - 1] ?? .init()
    }
    
    func moveToNextCampus(currentCampus: Campus) -> Campus {
        let index = campus?.firstIndex(of: currentCampus) ?? .init()
        
        guard let totalCampus = campus?.count, index != totalCampus - 1 else {
            return campus?.first ?? .init()
        }
        
        return campus?[index + 1] ?? .init()
    }
    
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
                              latitude: campus.element["latitude"] as? Double ?? 0,
                              longitude: campus.element["longitude"] as? Double ?? 0,
                              pastorName: campus.element["pastorName"] as? String ?? "",
                              pastorLastname: campus.element["pastorLastname"] as? String ?? "",
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
