//
//  ViewModifier+Extensions.swift
//  ibvn
//
//  Created by Jose Letona on 3/4/24.
//

import SwiftUI

struct TopBar: ViewModifier {
    @State var openSignInView: Bool = false
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        openWhatsApp()
                    } label: {
                        Image(systemName: "ellipsis.message.fill")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Image("IbvnLogo")
                        .resizable()
                        .frame(width: 120, height: 31)
                        .onTapGesture {
                            openSignInView.toggle()
                        }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if let url = URL(string: "https://donaciones.ibvn.org") {
                        Link(destination: url) {
                            Image(systemName: "gift")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .sheet(isPresented: $openSignInView, content: {
                SignInView()
            })
    }
    
    func openWhatsApp() {
            let phoneNumber = "50379100309"
            if let url = URL(string: "https://wa.me/\(phoneNumber)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
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
