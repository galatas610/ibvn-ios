//
//  ViewModifier+Extensions.swift
//  ibvn
//
//  Created by Jose Letona on 3/4/24.
//

import SwiftUI

struct TopBar: ViewModifier {
    // MARK: Property Wrappers
    @State private var openSignInView: Bool = false
    
    // MARK: Body
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("IbvnLogo")
                        .resizable()
                        .frame(width: 120, height: 31)
                        .onTapGesture {
                            openSignInView.toggle()
                        }
                }
            }
            .toolbarBackground(Constants.fondoOscuro, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $openSignInView, content: {
                SignInView()
            })
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
