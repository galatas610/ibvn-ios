//
//  TopBar.swift
//  ibvn
//
//  Created by Jose Letona on 2/4/24.
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
