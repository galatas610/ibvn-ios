//
//  Pastor.swift
//  ibvn
//
//  Created by joseletona on 25/6/25.
//

import Foundation

struct Pastor: Equatable {
    let id: UUID
    let image: String?
    let name: String?
    let lastname: String?
    let rol: String?
    
    init(
        id: UUID,
        image: String = "",
        name: String = "",
        lastname: String = "",
        rol: String = ""
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.lastname = lastname
        self.rol = rol
    }
}
