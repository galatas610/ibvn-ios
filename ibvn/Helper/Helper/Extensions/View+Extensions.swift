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

extension AppFontFamily {
    
    func fontName(style: AppFontStyle) -> String {
        let moldinMap: [AppFontStyle: String] = [
            .black: "Moldin-Black",
            .extraBold: "Moldin-ExtraBold",
            .bold: "Moldin-Bold",
            .semiBold: "Moldin-SemiBold",
            .medium: "Moldin-Medium",
            .regular: "Moldin-Regular"
        ]
        
        let dmSansMap: [AppFontStyle: String] = [
            .black: "DMSans-Black",
            .blackItalic: "DMSans-BlackItalic",
            .extraBold: "DMSans-ExtraBold",
            .extraBoldItalic: "DMSans-ExtraBoldItalic",
            .bold: "DMSans-Bold",
            .boldItalic: "DMSans-BoldItalic",
            .semiBold: "DMSans-SemiBold",
            .semiBoldItalic: "DMSans-SemiBoldItalic",
            .medium: "DMSans-Medium",
            .mediumItalic: "DMSans-MediumItalic",
            .regular: "DMSans-Regular",
            .italic: "DMSans-Italic",
            .light: "DMSans-Light",
            .lightItalic: "DMSans-LightItalic",
            .thin: "DMSans-Thin",
            .thinItalic: "DMSans-ThinItalic"
        ]
        
        let map: [AppFontStyle: String]
        
        switch self {
        case .moldin:
            map = moldinMap
        case .dmSans:
            map = dmSansMap
        }
        
        if let name = map[style] {
            return name
        }
        
        // Preserve previous fatalError behavior for unsupported combinations
        fatalError("❌ \(self) no soporta el estilo \(style)")
    }
}

extension View {
    
    func appFont(
        _ family: AppFontFamily,
        _ style: AppFontStyle = .regular,
        size: CGFloat
    ) -> some View {
        self.font(.custom(family.fontName(style: style), size: size))
    }
}
