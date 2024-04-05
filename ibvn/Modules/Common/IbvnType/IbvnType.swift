//
//  IbvnType.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation

enum IbvnType {
    case elRestoDeHoy
    case nocheDeViernes
    case preaches
    
    var viewTitle: String {
        switch self {
        case .elRestoDeHoy:
            "El Reto de Hoy"
        case .nocheDeViernes:
            "Noche de Viernes"
        case .preaches:
            "Mensajes"
        }
    }
    
    var localDataFileName: String {
        switch self {
        case .elRestoDeHoy:
            "ERDHLists"
        case .nocheDeViernes:
            "NDVLists"
        case .preaches:
            "PreachesLists"
        }
    }
}
