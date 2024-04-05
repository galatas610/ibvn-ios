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
    
    @ViewBuilder
    func show(when condition: Bool) -> some View {
        if condition {
            self
        } else {
            EmptyView()
                .hidden()
        }
    }
}
