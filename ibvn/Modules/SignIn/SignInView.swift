//
//  SignInView.swift
//  ibvn
//
//  Created by joseletona on 29/1/25.
//

import SwiftUI

struct SignInView: View {
    // MARK: - Property Wrappers
    @StateObject private var viewModel = SignInViewModel()
    @State private var shouldNavigate = false
    @FocusState var focusField: FocusType?
    
    // MARK: - body
    var body: some View {
        VStack {
            signInForm
            
            if viewModel.isShowSettings {
                SettingsView(viewModel: SettingsViewModel())
            }
            
            Spacer()
        }
        .navigationTitle("Ingresar")
        .showAlert(viewModel.alertInfo, when: $viewModel.alertIsPresenting)
    }
    
    // MARK: - Variables
    var signInForm: some View {
        Form {
            Section {
                TextField("Correo Electrónico", text: $viewModel.email)
                    .textFieldStyle(FormTextField())
                    .focused($focusField, equals: .email)
                    .id(FocusField.email)
                
                SecureField("Contraseña", text: $viewModel.password)
                    .textFieldStyle(FormTextField())
                    .focused($focusField, equals: .password)
                    .id(FocusField.password)
                
                signInButton
            } header: {
                Text("Credenciales")
            } footer: {
                VStack(alignment: .leading) {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color(.systemTeal))
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Listo") {
                    setFocus(on: nil)
                }
            }
        }
    }
    
    var signInButton: some View {
        Button(action: {
            viewModel.login()
        }, label: {
            Text("Ingresar")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(ActionButton())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

extension SignInView: FormType {
    enum FocusField: FocusFieldType {
        case email
        case password
    }
    
    func setFocus(on focusField: FocusField?) {
        self.focusField = focusField
    }
}

#Preview {
    SignInView()
}
