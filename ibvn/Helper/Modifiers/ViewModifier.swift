//
//  ViewModifier+Extensions.swift
//  ibvn
//
//  Created by Jose Letona on 3/4/24.
//

import SwiftUI

struct TopBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("IbvnLogo")
                        .resizable()
                        .frame(width: 120, height: 31)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if let url = URL(string: "https://ibvn.org/formas-de-dar/") {
                        Link(destination: url) {
                            Text("Formas de dar")
                                .foregroundColor(.accentColor)
                                .bold()
                        }
                    }
                }
            }
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
