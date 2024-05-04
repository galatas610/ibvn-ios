//
//  Campus.swift
//  ibvn
//
//  Created by Jose Letona on 1/5/24.
//

import Foundation

struct Campus: Equatable {
    let name: String?
    let address: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
    let pastorName: String?
    let pastorLastname: String?
    let pastorImage: String?
    let phone: String?
    let whatsapp: String?
    
    init(
        name: String = "",
        address: String = "",
        country: String = "",
        latitude: Double = 0,
        longitude: Double = 0,
        pastorName: String = "",
        pastorLastname: String = "",
        pastorImage: String = "",
        phone: String = "",
        whatsapp: String = ""
    ) {
        self.name = name
        self.address = address
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.pastorName = pastorName
        self.pastorLastname = pastorLastname
        self.pastorImage = pastorImage
        self.phone = phone
        self.whatsapp = whatsapp
    }
}
