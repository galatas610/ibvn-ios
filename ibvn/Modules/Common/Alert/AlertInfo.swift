//
//  AlertInfo.swift
//  ibvn
//
//  Created by Jose Letona on 6/4/24.
//

import Foundation

enum AlertType {
    case info
    case warning
    case error
}

struct AlertInfo {
    let title: String
    let message: String
    let type: AlertType
    let leftButtonConfiguration: ButtonConfiguration
    var rightButtonConfiguration: ButtonConfiguration?
}

struct ButtonConfiguration {
    let title: String
    var buttonAction: () -> Void
}

extension ButtonConfiguration {
    static var okConfiguration: Self {
        ButtonConfiguration(title: "Entendido", buttonAction: {})
    }
    
    static var cancelConfiguration: Self {
        ButtonConfiguration(title: "Cancelar", buttonAction: {})
    }
}
