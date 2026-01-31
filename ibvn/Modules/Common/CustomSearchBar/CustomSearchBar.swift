//
//  CustomSearchBar.swift
//  ibvn
//
//  Created by joseletona on 31/1/26.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Constants.textoPrincipal)

            TextField("Buscar", text: $text)
                .appFont(.dmSans, .regular, size: 14)
                .foregroundStyle(.white)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Constants.textoPrincipal)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Constants.acentoVerde)
        )
        .padding(.horizontal)
    }
}
