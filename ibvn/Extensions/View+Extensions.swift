//
//  View+Extensions.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import SwiftUI

extension View {
    
    func navigationBarBackButtonTitleHidden() -> some View {
        self.modifier(BackButtonTitleHiddenModifier())
    }
    
    func navigationBarTitleColor(_ color: Color) -> some View {
        return self.modifier(NavigationBarTitleColorModifier(color: color))
    }
}

struct BackButtonTitleHiddenModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    @ViewBuilder @MainActor func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: button)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width > .zero
                            && value.translation.height > -30
                            && value.translation.height < 30 {
                            dismiss()
                        }
                    }
            )
    }
    
    var button: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.accentColor)
            .imageScale(.large)
        }
    }
}

struct NavigationBarTitleColorModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let coloredAppearance = UINavigationBarAppearance()
                
                coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(color)]
                
                coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                
                UINavigationBar.appearance().standardAppearance = coloredAppearance
                
                UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
            }
    }
}
