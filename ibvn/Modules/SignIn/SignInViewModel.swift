//
//  SignInViewModel.swift
//  ibvn
//
//  Created by joseletona on 29/1/25.
//

import Foundation
import FirebaseAuth

class SignInViewModel: ObservableObject, PresentAlertType {
    // MARK: - Property Wrapper
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var closeMainFlow: Bool = false
    @Published var alertInfo: AlertInfo?
    
    // MARK: - Variables
    @Published var alertIsPresenting: Bool = false
    
    // MARK: - Initialization
    init() {}
    
    // MARK: - Functions
    private func validateInfo() -> Bool {
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "⚠ Favor completar todos los campos."
            
            return false
        }
        
        guard email.contains("@"), email.contains(".") else {
            errorMessage = "⚠ Favor ingresar un correo válido."
            
            return false
        }
        
        return true
    }
    
    func login() {
        guard validateInfo() else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else {
                self?.displayError(error)
                
                return
            }
            
            guard let isEmailVerified = result?.user.isEmailVerified else {
                self?.displayError(error)
                
                return
            }
            
            let loginSuccessful = AlertInfo(title: "Información",
                                            message: "Inicio de sesión exitoso.",
                                            type: .info,
                                            leftButtonConfiguration: ButtonConfiguration(title: "Ir a configuración",
                                                                                         buttonAction: { self?.closeMainFlow.toggle() }))
            
            let emailUnVerified = AlertInfo(title: "Información",
                                            message: "Su correo necesita verificación",
                                            type: .warning,
                                            leftButtonConfiguration: ButtonConfiguration(title: "Ok",
                                                                                         buttonAction: { self?.signOut() }),
                                            rightButtonConfiguration: ButtonConfiguration(title: "¿Enviar correo nuevamente?",
                                                                                          buttonAction: { self?.resendEmailVerification() }))
            
            if isEmailVerified {
                self?.setupAlertInfo(loginSuccessful)
            } else {
                self?.setupAlertInfo(emailUnVerified)
            }
        }
    }
    
    func resendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification { [weak self] error in
            self?.signOut()
            
            guard error == nil else {
                self?.displayError()
                
                return
            }
            
            self?.setupAlertInfo(AlertInfo(title: "Verificar Correo",
                                           message: "Favor verficiar tu bandeja de entrada para validar tu correo.",
                                           type: .info,
                                           leftButtonConfiguration: ButtonConfiguration(title: "Ok",
                                                                                        buttonAction: {})))
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            displayError(error)
        }
    }
}

// MARK: - Alert
extension SignInViewModel {
    func setupAlertInfo(_ alert: AlertInfo) {
        presentAlert(alert)
    }
    
    private func displayError() {
        let configuration = ButtonConfiguration(
            title: "Ok",
            buttonAction: {}
        )
        
        alertInfo = AlertInfo(
            title: "Error",
            message: "Favor verificar sus credenciales",
            type: .error,
            leftButtonConfiguration: configuration
        )
        
        presentAlert(alertInfo)
    }
}
