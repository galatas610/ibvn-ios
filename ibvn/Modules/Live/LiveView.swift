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
