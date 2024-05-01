//
//  CloudPlaylist.swift
//  ibvn
//
//  Created by Jose Letona on 14/4/24.
//

import Foundation

// MARK: - Item
struct CloudPlaylist: Codable {
    let id: String
    let snippet: SnippetCloud
    
    init(
        id: String = "",
        snippet: SnippetCloud = .init()
    ) {
        self.id = id
        self.snippet = snippet
    }
}

// MARK: - Snippet
struct SnippetCloud: Codable {
    let publishedAt: String
    let title: String
    let description: String
    let thumbnailUrl: String
    let thumbnailWidth: Int
    let thumbnailHeight: Int
    
    enum CodingKeys: CodingKey {
        case publishedAt
        case title
        case description
        case thumbnailUrl
        case thumbnailWidth
        case thumbnailHeight
    }
    
    init(
        publishedAt: String = "",
        title: String = "",
        description: String = "",
        thumbnailUrl: String = "",
        thumbnailWidth: Int = 0,
        thumbnailHeight: Int = 0
    ) {
        self.publishedAt = publishedAt
        self.title = title
        self.description = description
        self.thumbnailUrl = thumbnailUrl
        self.thumbnailWidth = thumbnailWidth
        self.thumbnailHeight = thumbnailHeight
    }
}
