//
//  LiveView.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import SwiftUI

struct LiveView: View {
    // MARK: Property Wrappers
    @StateObject private var viewModel: LiveViewModel
    @State private var safariURL: URL?
    @State private var safariItem: SafariItem?
    
    // MARK: Initialization
    init(viewModel: LiveViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ZStack {
                    Constants.fondoOscuro
                        .ignoresSafeArea()
                    
                    Image("IbvnLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 31)
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        liveHeader
                        liveContent
                        quickLinks
                        donateButton
                        
                        Spacer()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .modifier(TopBar())
                }
                .scrollIndicators(.hidden)
                .background(Constants.fondoOscuro)
            }
        }
        .sheet(item: $safariItem) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
    }
    
    private var liveHeader: some View {
        Group {
            switch viewModel.cloudLive.state {
            case .live:
                Text("EN VIVO")
            case .upcoming:
                Text("Próximo en vivo")
            case .last:
                Text("Última transmisión")
            }
        }
        .appFont(.dmSans, .black, size: 32).tracking(-2)
        .foregroundStyle(.white)
        .padding(.leading)
        .padding(.bottom, -4)
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(
            .spring(response: 0.4, dampingFraction: 0.8),
            value: viewModel.cloudLive.state
        )
    }
    
    private var liveContent: some View {
        ZStack {
            VideoLiveView(live: viewModel.cloudLive)
                .padding(.horizontal)
                .opacity(viewModel.cloudLive.videoId.isEmpty ? 0 : 1)
                .animation(
                    .easeInOut(duration: 0.35),
                    value: viewModel.cloudLive.videoId
                )
            
            if viewModel.cloudLive.videoId.isEmpty {
                Text("No hay transmisión disponible")
                    .appFont(.dmSans, .medium, size: 16)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }
        }
    }
    
    private var quickLinks: some View {
        VStack(alignment: .leading) {
            Text("Quick links")
                .appFont(.dmSans, .medium, size: 16)
                .foregroundStyle(Constants.acentoVerde)
            
            HStack {
                GradientButton(text: "WhatsApp", image: "whatsApp") {
                    viewModel.openWhatsApp(phone: "25228106", message: "¡Hola! Quiero más información de la iglesia.")
                }
                
                Spacer()
                
                GradientButton(text: "+ Vida Nueva", image: "linkTree") {
                    openSafari(url: "https://linktr.ee/ibvidanueva")
                }
                
                Spacer()
                
                GradientButton(text: "Campus", image: "location") {
                    openSafari(url: "https://ibvn.org")
                }
            }
        }
        .padding()
    }
    
    private var donateButton: some View {
        HStack {
            OutlineButton(text: "Formas de donar", image: "donate") {
                openSafari(url: "https://donaciones.ibvn.org/")
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 12)
    }
    
    private func openSafari(url: String) {
        guard let validURL = URL(string: url) else { return }
        
        safariItem = SafariItem(url: validURL)
    }
}

#Preview {
    LiveView(viewModel: LiveViewModel(ibvnType: .live))
}
