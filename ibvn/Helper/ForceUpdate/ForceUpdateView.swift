//
//  ForceUpdateView.swift
//  ibvn
//

import SwiftUI

struct ForceUpdateView: View {
    let storeUrl: URL?

    var body: some View {
        ZStack {
            Constants.fondoOscuro
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image("IbvnLogo")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)

                Text("Actualización requerida")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("Hay una versión más reciente disponible. Actualiza para seguir disfrutando de todas las funciones.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button {
                    if let storeUrl { UIApplication.shared.open(storeUrl) }
                } label: {
                    Text("Actualizar ahora")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(storeUrl == nil ? Color.gray : Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(storeUrl == nil)
                .padding(.horizontal, 32)
                .padding(.top, 8)
            }
        }
    }
}
