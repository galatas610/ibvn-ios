//
//  YoutubeVideo.swift
//  ibvn
//
//  Created by Jose Letona on 7/4/24.
//

import Foundation

struct YoutubeVideo: Codable {
    let kind, etag: String
    let items: [VideoItem]
    let pageInfo: VideoPageInfo
    
    init(kind: String = "", etag: String = "", items: [VideoItem] = [], pageInfo: VideoPageInfo = .init()) {
        self.kind = kind
        self.etag = etag
        self.items = items
        self.pageInfo = pageInfo
    }
}

// MARK: - Item
struct VideoItem: Codable {
    let kind, etag: String
    var id: String
    let snippet: VideoSnippet
}

// MARK: - Snippet
struct VideoSnippet: Codable {
    let publishedAt: String
    let channelID, title, description: String
    let thumbnails: VideoThumbnails
    let channelTitle, categoryID: String
    let liveBroadcastContent: LiveBroadcastContent
    let localized: Localized
    let defaultAudioLanguage: String

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title, description, thumbnails, channelTitle
        case categoryID = "categoryId"
        case liveBroadcastContent
        case localized, defaultAudioLanguage
    }
}

// MARK: LiveBroadcastContent
enum LiveBroadcastContent: String, Codable {
    case none
    case live
    case upcoming
    
    var title: String {
        switch self {
        case .none:
            "Último en vivo"
        case .live, .upcoming:
            "En Vivo"
        }
    }
}

// MARK: - Localized
struct Localized: Codable {
    let title, description: String
}

// MARK: - Thumbnails
struct VideoThumbnails: Codable {
    let thumbnailsDefault, medium, high, standard: Default
    let maxres: Default?

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high, standard, maxres
    }
}

// MARK: - Default
struct Default: Codable {
    let url: String
    let width, height: Int
}

// MARK: - PageInfo
struct VideoPageInfo: Codable {
    let totalResults, resultsPerPage: Int
    
    init(totalResults: Int = 0, resultsPerPage: Int = 0) {
        self.totalResults = totalResults
        self.resultsPerPage = resultsPerPage
    }
}
