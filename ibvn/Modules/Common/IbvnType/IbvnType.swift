//
//  IbvnType.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation

enum IbvnType {
    case elRetoDeHoy
    case nocheDeViernes
    case preaches
    case live
    case liveOff
    case series
    case podcast
    case recommended
    case recommendedSunday
    case recommendedNDVN
    
    var viewTitle: String {
        switch self {
        case .live:
            "En Vivo"
        case .liveOff:
            "En Vivo OFF"
        case .series, .preaches, .nocheDeViernes:
            "Series de Mensajes"
        case .podcast, .elRetoDeHoy:
            "Podcast"
        case .recommended, .recommendedSunday, .recommendedNDVN:
            "Recomendados"
        }
    }
    
    var localDataFileName: String {
        switch self {
        case .elRetoDeHoy:
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
        case .podcast:
            "PodcastLists"
        case .recommended:
            "RecommendedList"
        case .recommendedSunday:
            "RecommendedSundayList"
        case .recommendedNDVN:
            "RecommendedNDVNLists"
        }
    }
    
    var hashTag: String {
        switch self {
        case .elRetoDeHoy:
            "#ElRetoDeHoy"
        case .nocheDeViernes:
            "#NDV"
        case .podcast:
            "#Podcast"
        case .recommendedSunday:
            "#RecomendadaDomingo"
        case .recommendedNDVN:
            "#RecomendadaNDVN"
        case .recommended:
            "#Recomendada"
        case .preaches, .live, .liveOff, .series:
            ""
        }
    }
}
