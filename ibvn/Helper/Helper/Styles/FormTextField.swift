//
//  FormTextField.swift
//  ibvn
//
//  Created by joseletona on 29/1/25.
//

import SwiftUI

struct FormTextField: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .textFieldStyle(DefaultTextFieldStyle())
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .keyboardType(.default)
    }
}
