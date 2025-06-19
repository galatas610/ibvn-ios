//
//  View+Extensions.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func show(when condition: Bool) -> some View {
        if condition {
            self
        } else {
            EmptyView()
                .hidden()
        }
    }
    
    /// Simplifies showing an alertInfo object to one line
    func showAlert(_ alertInfo: AlertInfo?, when isPresenting: Binding<Bool>) -> some View {
        self
            .alert(alertInfo?.title ?? "",
                   isPresented: isPresenting,
                   presenting: alertInfo) { alertInfo in
                switch alertInfo.type {
                case .warning:
                    Button(alertInfo.leftButtonConfiguration.title,
                           role: .cancel,
                           action: alertInfo.leftButtonConfiguration.buttonAction)
                    Button(alertInfo.rightButtonConfiguration?.title ?? "",
                           action: alertInfo.rightButtonConfiguration?.buttonAction ?? {})
                    .keyboardShortcut(.defaultAction)
                case .error, .info:
                    Button(alertInfo.leftButtonConfiguration.title,
                           action: alertInfo.leftButtonConfiguration.buttonAction)
                }
            } message: { detail in
                Text(detail.message)
            }
    }
}
