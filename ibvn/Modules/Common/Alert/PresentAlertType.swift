//
//  PresentAlertType.swift
//  ibvn
//
//  Created by Jose Letona on 6/4/24.
//

import Foundation

protocol PresentAlertType: AnyObject {
    var alertIsPresenting: Bool { get set }
    var alertInfo: AlertInfo? { get set }
    
    func presentAlert(_ alertInfo: AlertInfo?)
}

extension PresentAlertType {
    func presentAlert(_ alertInfo: AlertInfo?) {
        guard let alertInfo = alertInfo else {
            return
        }
        
        self.alertInfo = alertInfo
        alertIsPresenting = true
    }
    
    func displayError(_ error: Error?) {
        let configuration = ButtonConfiguration(
            title: "Entendido",
            buttonAction: {}
        )
        
        guard let errorMessage = error?.localizedDescription else {
            return
        }
                
        alertInfo = AlertInfo(
            title: "Error",
            message: errorMessage,
            type: .error,
            leftButtonConfiguration: configuration
        )
        
        presentAlert(alertInfo)
    }
}
