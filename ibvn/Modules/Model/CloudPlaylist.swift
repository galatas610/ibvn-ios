//
//  CloudPlaylist.swift
//  ibvn
//
//  Created by Jose Letona on 14/4/24.
//

import Foundation

// MARK: - Item
struct CloudPlaylist: Codable, Hashable {
    let id: String
    let publishedAt: String
    let title: String
    let description: String
    let thumbnailUrl: String
    let thumbnailWidth: Int
    let thumbnailHeight: Int
    let updatedAt: TimeInterval
    
    init(
        id: String = "",
        publishedAt: String = "",
        title: String = "",
        description: String = "",
        thumbnailUrl: String = "",
        thumbnailWidth: Int = 0,
        thumbnailHeight: Int = 0,
        updatedAt: TimeInterval = 0
    ) {
        self.id = id
        self.publishedAt = publishedAt
        self.title = title
        self.description = description
        self.thumbnailUrl = thumbnailUrl
        self.thumbnailWidth = thumbnailWidth
        self.thumbnailHeight = thumbnailHeight
        self.updatedAt = updatedAt
    }
}
