//
//  String+Extensions.swift
//  ibvn
//
//  Created by Jose Letona on 26/3/24.
//

import Foundation

extension String {
    func formatDate() -> String {
        String(self.prefix(10))
    }
}

extension String {
    func normalizedForSearch() -> String {
        self
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined(separator: " ")
    }
}
