//
//  SafariView.swift
//  ibvn
//
//  Created by José Letona Rodríguez on 1/30/26.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    // MARK: Variables
    let url: URL

    // MARK: Fucntions
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: Context
    ) {}
}

struct SafariItem: Identifiable {
    let id = UUID()
    let url: URL
}
