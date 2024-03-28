//
//  YouTubeSeach.swift
//  ibvn
//
//  Created by Jose Letona on 27/3/24.
//

import Foundation

// MARK: - YoutubeSearch
struct YoutubeSearch: Codable {
    let kind: String
    let etag: String
    let regionCode: String
    let pageInfo: PageInfo
    let items: [Item]
    
    init(kind: String = "",
         etag: String = "",
         regionCode: String = "",
         pageInfo: PageInfo = .init(),
         items: [Item] = []) {
        self.kind = kind
        self.etag = etag
        self.regionCode = regionCode
        self.pageInfo = pageInfo
        self.items = items
    }
}

// MARK: - Item
struct Item: Codable {
    let kind: String
    let etag: String
    let id: ID
    let snippet: Snippet
    
    enum CodingKeys: String, CodingKey {
        case kind
        case etag
        case id
        case snippet
    }
}

// MARK: - ID
struct ID: Codable {
    let kind: String
    let videoId: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoId
    }
}

// MARK: - Snippet
struct Snippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let liveBroadcastContent: LiveBroadcastContent?
    let publishTime: String?

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelId
        case title
        case description
        case thumbnails
        case channelTitle
        case liveBroadcastContent
        case publishTime
    }
    
    init(publishedAt: String = "", channelId: String = "", title: String = "", description: String = "", thumbnails: Thumbnails = .init(), channelTitle: String = "", liveBroadcastContent: LiveBroadcastContent? = nil, publishTime: String? = "") {
        self.publishedAt = publishedAt
        self.channelId = channelId
        self.title = title
        self.description = description
        self.thumbnails = thumbnails
        self.channelTitle = channelTitle
        self.liveBroadcastContent = liveBroadcastContent
        self.publishTime = publishTime
    }
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let `default`: ThumbnailsInfo
    let medium: ThumbnailsInfo
    let high: ThumbnailsInfo

    enum CodingKeys: String, CodingKey {
        case `default`
        case medium
        case high
    }
    
    init(`default`: ThumbnailsInfo = .init(), medium: ThumbnailsInfo = .init(), high: ThumbnailsInfo = .init()) {
        self.medium = medium
        self.high = high
        self.default = `default`
    }
}

// MARK: - Default
struct ThumbnailsInfo: Codable {
    let url: String
    let width: Int
    let height: Int
    
    init(url: String = "", width: Int = 0, height: Int = 0) {
        self.url = url
        self.width = width
        self.height = height
    }
}

enum LiveBroadcastContent: String, Codable {
    case none = "none"
}


// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
    
    init(totalResults: Int = 0, resultsPerPage: Int = 0) {
        self.totalResults = totalResults
        self.resultsPerPage = resultsPerPage
    }
}
