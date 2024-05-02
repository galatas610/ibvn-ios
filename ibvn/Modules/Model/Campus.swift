//
//  Campus.swift
//  ibvn
//
//  Created by Jose Letona on 1/5/24.
//

import Foundation

struct Campus {
    let name: String
    let address: String
    let country: String
    let latitude: Int
    let longitude: Int
    let pastor: String
    let pastorImage: String
    let phone: String
    let whatsapp: String
    
    init(
        name: String = "",
        address: String = "",
        country: String = "",
        latitude: Int = 0,
        longitude: Int = 0,
        pastor: String = "",
        pastorImage: String = "",
        phone: String = "",
        whatsapp: String = ""
    ) {
        self.name = name
        self.address = address
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.pastor = pastor
        self.pastorImage = pastorImage
        self.phone = phone
        self.whatsapp = whatsapp
    }
}
