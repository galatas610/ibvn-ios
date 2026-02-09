//
//  YoutubePlaylists.swift
//  ibvn
//
//  Created by Jose Letona on 14/4/24.
//

import Foundation

// MARK: - Welcome
struct YoutubePlaylists: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String?
    let prevPageToken: String?
    let pageInfo: PageInfo
    let items: [ItemResponse]
    
    init(
        kind: String = "",
        etag: String = "",
        nextPageToken: String = "",
        prevPageToken: String = "",
        items: [ItemResponse] = [],
        pageInfo: PageInfo = .init()
    ) {
        self.kind = kind
        self.etag = etag
        self.nextPageToken = nextPageToken
        self.prevPageToken = prevPageToken
        self.items = items
        self.pageInfo = pageInfo
    }
}

// MARK: - Item
struct ItemResponse: Codable {
    let kind: KindResponse
    let etag: String
    let id: String
    let snippet: SnippetResponse
}

enum KindResponse: String, Codable {
    case youtubePlaylist = "youtube#playlist"
}

// MARK: - Snippet
struct SnippetResponse: Codable {
    let publishedAt: String
    let channelId: ChannelIdResponse
    let title: String
    let description: String
    let thumbnails: ThumbnailsResponse
    let channelTitle: ChannelTitleResponse
    let localized: LocalizedResponse
    
    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelId
        case title
        case description
        case thumbnails
        case channelTitle
        case localized
    }
}

enum ChannelIdResponse: String, Codable {
    case uCoNq7HF7VnqalfgLTaxrDQ = "UCoNq7HF7vnqalfg-lTaxrDQ"
}

enum ChannelTitleResponse: String, Codable {
    case iglesiaBautistaVidaNueva = "Iglesia Bautista Vida Nueva"
}

// MARK: - Localized
struct LocalizedResponse: Codable {
    let title, description: String
}

// MARK: - Thumbnails
struct ThumbnailsResponse: Codable {
    let `default`: Thumbnails?
    let medium: Thumbnails?
    let high: Thumbnails?
    let standard: Thumbnails?
    let maxres: Thumbnails?

    enum CodingKeys: String, CodingKey {
        case `default`
        case medium
        case high
        case standard
        case maxres
    }

    init(
        `default`: Thumbnails? = nil,
        medium: Thumbnails? = nil,
        high: Thumbnails? = nil,
        standard: Thumbnails? = nil,
        maxres: Thumbnails? = nil
    ) {
        self.default = `default`
        self.medium = medium
        self.high = high
        self.standard = standard
        self.maxres = maxres
    }
}
