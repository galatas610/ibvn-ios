//
//  KeyboardSearchField.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 3/7/26.
//

import SwiftUI
import UIKit

struct KeyboardSearchField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = "Buscar"

    final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        weak var textField: UITextField?

        init(text: Binding<String>) {
            _text = text
        }

        @objc func textDidChange(_ sender: UITextField) {
            text = sender.text ?? ""
        }

        @objc func dismissKeyboard() {
            textField?.resignFirstResponder()
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        context.coordinator.textField = textField

        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.text = text
        textField.textColor = .white
        textField.tintColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.clearButtonMode = .never
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textDidChange(_:)),
            for: .editingChanged
        )

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flex = UIBarButtonItem(systemItem: .flexibleSpace)
        let dismiss = UIBarButtonItem(
            image: UIImage(systemName: "keyboard.chevron.compact.down"),
            style: .plain,
            target: context.coordinator,
            action: #selector(Coordinator.dismissKeyboard)
        )

        toolbar.items = [flex, dismiss]
        textField.inputAccessoryView = toolbar

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }

        uiView.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.7)
            ]
        )
    }
}
