//
//  SettingsView.swift
//  ibvn
//
//  Created by Jose Letona on 10/4/24.
//

import SwiftUI

struct SettingsView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: SettingsViewModel
    
    // MARK: Initialization
    init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    viewModel.syncLive()
                } label: {
                    Text("Sincronizar en vivo")
                }
                .buttonStyle(.bordered)
                .padding()
                
                Button {
                    viewModel.syncPlaylist()
                } label: {
                    Text("Sincronizar listas")
                }
                .buttonStyle(.bordered)
                .padding()
                
                Spacer()
                
                HStack {
                    Text(viewModel.viewMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Spacer()
                }
            }
            .showAlert(viewModel.alertInfo, when: $viewModel.alertIsPresenting)
        }
        .navigationTitle("Configuración")
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
