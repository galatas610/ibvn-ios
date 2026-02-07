//
//  IbvnType.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation

enum IbvnType {
    case series
    case podcast
    case recommended
    case recommendedSunday
    case recommendedNDVN
    case elRetoDeHoy
    case nocheDeViernes
    case preaches
    case live
    case liveOff
}

extension IbvnType {
    var viewTitle: String {
           switch self {
           case .series:
               return "Series de Mensajes"
           case .podcast:
               return "Podcast"
           case .recommended,
                .recommendedSunday,
                .recommendedNDVN:
               return "Recomendados"
           case .live:
               return "En Vivo"
           case .liveOff:
               return "En Vivo OFF"
           default:
               return ""
           }
       }
    
    var includeTags: [String] {
            switch self {
            case .podcast:
                return ["#Podcast", "#ElRetoDeHoy"]
            case .recommended:
                return ["#Recomendada"]
            case .recommendedSunday:
                return ["#RecomendadaDomingo"]
            case .recommendedNDVN:
                return ["#RecomendadaNDVN"]
            case .nocheDeViernes:
                return ["#NDV"]
            case .elRetoDeHoy:
                return ["#ElRetoDeHoy"]
            default:
                return []
            }
        }

        var excludeTags: [String] {
            switch self {
            case .series:
                return ["#Podcast", "#ElRetoDeHoy"]
            default:
                return []
            }
        }
}
