//
//  Live.swift
//  ibvn
//
//  Created by Jose Letona on 7/4/24.
//

import Foundation

struct Live: Codable {
    let kind, etag, regionCode: String
    let pageInfo: LivePageInfo
    let items: [LiveItem]
    
    init(kind: String = "", etag: String = "", regionCode: String = "", pageInfo: LivePageInfo = .init(), items: [LiveItem] = []) {
        self.kind = kind
        self.etag = etag
        self.regionCode = regionCode
        self.pageInfo = pageInfo
        self.items = items
    }
}

// MARK: - Item
struct LiveItem: Codable {
    let kind, etag: String
    var id: LiveId
    let snippet: LiveSnippet
}

// MARK: - ID
struct LiveId: Codable {
    let kind: String
    var videoId: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoId
    }
}

// MARK: - Snippet
struct LiveSnippet: Codable {
    let publishedAt: String
    let channelID, title, description: String
    let thumbnails: LiveThumbnails
    let channelTitle, liveBroadcastContent: String
    let publishTime: String

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title, description, thumbnails, channelTitle, liveBroadcastContent, publishTime
    }
}

// MARK: - Thumbnails
struct LiveThumbnails: Codable {
    let thumbnailsDefault, medium, high: LiveDefault

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high
    }
}

// MARK: - Default
struct LiveDefault: Codable {
    let url: String
    let width, height: Int
}

// MARK: - PageInfo
struct LivePageInfo: Codable {
    let totalResults, resultsPerPage: Int
    
    init(totalResults: Int = 0, resultsPerPage: Int = 0) {
        self.totalResults = totalResults
        self.resultsPerPage = resultsPerPage
    }
}
