//
//  IbvnApp.swift
//  ibvn
//
//  Created by Jose Letona on 25/3/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}

@main
struct IbvnApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var isShowingSplash = true
    @StateObject private var forceUpdate = ForceUpdateService.shared

    var body: some Scene {
        WindowGroup {
            ZStack {

                if forceUpdate.isUpdateRequired {
                    ForceUpdateView(storeUrl: forceUpdate.storeUrl)
                        .preferredColorScheme(.dark)
                } else {
                    // 🔥 Main App
                    TabBarView()
                        .preferredColorScheme(.dark)

                    // 🔥 Splash Overlay
                    if isShowingSplash {
                        SplashView()
                            .transition(.opacity)
                    }
                }
            }
            .task {
                await forceUpdate.check()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        isShowingSplash = false
                    }
                }
            }
        }
    }
}

struct SplashView: View {
    
    @State private var logoOpacity = 0.0
    
    var body: some View {
        ZStack {
            
            // 🎨 Fondo desde Constants
            Constants.fondoOscuro
                .ignoresSafeArea()
            
            // 🖼 Logo centrado
            Image("IbvnLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 277)
                .opacity(logoOpacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                logoOpacity = 1
            }
        }
    }
}
