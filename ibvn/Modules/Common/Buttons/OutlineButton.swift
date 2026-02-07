//
//  OutlineButton.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 1/31/26.
//

import SwiftUI

struct OutlineButton: View {
    var text: String
    var image: String = ""
    var showImage: Bool = true
    var fullWidth: Bool = true
    var action: () -> Void = { }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(text)
                    .appFont(.dmSans, .medium, size: 16)
                
                if showImage {
                    Image(image)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal)
            .padding(.vertical, showImage ? 12 : 4)
            .foregroundColor(Constants.textoPrincipal)
            .overlay(
                RoundedRectangle(cornerRadius: 1000)
                    .stroke(Color.white, lineWidth: 1)
            )
        }
    }
}
