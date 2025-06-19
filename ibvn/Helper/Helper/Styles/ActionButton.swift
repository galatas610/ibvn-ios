//
//  ActionButton.swift
//  ibvn
//
//  Created by joseletona on 29/1/25.
//

import SwiftUI

struct ActionButton: ButtonStyle {
    var color: Color = Color("Blue")
    var fontColor: Color = .orange
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(fontColor)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .animation(.easeOut, value: configuration.isPressed)
            .padding(.horizontal)
    }
}
