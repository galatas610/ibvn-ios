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
                        Text(viewModel.youtubeVideo.items.first?.snippet.liveBroadcastContent.title ?? "")
                            .appFont(.moldin, .regular, size: 48)
                            .padding(.leading)
                            .padding(.bottom, -2)
                        
                        if let lastLive = viewModel.youtubeVideo.items.first {
                            VideoLiveView(item: lastLive)
                                .padding(.horizontal)
                        }
                        
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
        .onAppear {
            viewModel.fetchCloudLive()
        }
        .sheet(item: $safariItem) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
    }
    
    private var quickLinks: some View {
        VStack(alignment: .leading) {
            Text("Quick links")
                .appFont(.dmSans, .medium, size: 16)
                .foregroundStyle(Constants.acentoVerde)
            
            HStack {
                gradientButton(text: "WhatsApp", icon: "whatsApp") {
                    viewModel.openWhatsApp(phone: "25228106", message: "¡Hola! Quiero más información de la iglesia.")
                }
                
                Spacer()
                
                gradientButton(text: "+ Vida Nueva", icon: "linkTree") {
                    openSafari(url: "https://linktr.ee/ibvidanueva")
                }
                
                Spacer()
                
                gradientButton(text: "Campus", icon: "location") {
                    openSafari(url: "https://ibvn.org")
                }
            }
        }
        .padding()
    }
    
    private func gradientButton(
        text: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(text)
                    .appFont(.dmSans, .bold, size: 12)
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
    
    private var donateButton: some View {
        HStack {
            Button {
                openSafari(url: "https://donaciones.ibvn.org/")
            } label: {
                HStack(spacing: 10) {
                    Text("Formas de donar")
                        .appFont(.dmSans, .medium, size: 16)
                    
                    Image("donate")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundColor(Constants.textoPrincipal)
                .overlay(
                    RoundedRectangle(cornerRadius: 1000)
                        .stroke(Color.white, lineWidth: 1)
                )
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
