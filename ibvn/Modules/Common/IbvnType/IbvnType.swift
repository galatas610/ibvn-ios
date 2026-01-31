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
    case live
    case liveOff
    case series
    
    var viewTitle: String {
        switch self {
        case .elRestoDeHoy:
            "El Reto de Hoy"
        case .nocheDeViernes:
            "Noche de Viernes"
        case .preaches:
            "Mensajes"
        case .live:
            "En Vivo"
        case .liveOff:
            "En Vivo OFF"
        case .series:
            "Series de Mensajes"
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
        case .live:
            "Live"
        case .liveOff:
            "LiveOff"
        case .series:
            "SeriesLists"
        }
    }
    
    var hashTag: String {
        switch self {
        case .elRestoDeHoy:
            "#ElRetoDeHoy"
        case .nocheDeViernes:
            "#NDV"
        case .preaches, .live, .liveOff, .series:
            ""
        }
    }
}
