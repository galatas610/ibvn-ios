//
//  GradientButton.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 1/31/26.
//

import SwiftUI

struct GradientButton: View {
    // MARK: Variables
    var text: String
    var image: String = ""
    var showImage: Bool = true
    var action: () -> Void
    
    // MARK: Body
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if showImage {
                    Image(image)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Text(text)
                    .appFont(.dmSans, showImage ? .bold : .medium, size: 12)
            }
            .padding(8)
            .foregroundColor(Constants.fondoOscuro)
            .background(
                LinearGradient(
                    colors: [
                        Constants.greenGradienteBase1,
                        Constants.greenGradienteBase2
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(1000)
        }
    }
}
