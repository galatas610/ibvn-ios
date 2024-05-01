//
//  YoutubePlaylist.swift
//  ibvn
//
//  Created by Jose Letona on 14/4/24.
//

import Foundation

// MARK: - Welcome
struct YoutubePlaylist: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String?
    let prevPageToken: String?
    let pageInfo: PageInfoResponse
    let items: [ItemResponse]
    
    init(
        kind: String = "",
        etag: String = "",
        nextPageToken: String = "",
        prevPageToken: String = "",
        items: [ItemResponse] = [],
        pageInfo: PageInfoResponse = .init()
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
    let `default`: ThumbnailsInfoResponse
    let medium: ThumbnailsInfoResponse
    let high: ThumbnailsInfoResponse

    enum CodingKeys: String, CodingKey {
        case `default`
        case medium
        case high
    }

    init(
        `default`: ThumbnailsInfoResponse = .init(),
        medium: ThumbnailsInfoResponse = .init(),
        high: ThumbnailsInfoResponse = .init()
    ) {
        self.medium = medium
        self.high = high
        self.default = `default`
    }
}

// MARK: - Default
struct ThumbnailsInfoResponse: Codable {
    let url: String
    let width: Int
    let height: Int

    init(
        url: String = "https://i.ytimg.com/vi/M15q_cNaJZc/hqdefault.jpg",
        width: Int = 480,
        height: Int = 360
    ) {
        self.url = url
        self.width = width
        self.height = height
    }
}

// MARK: - PageInfo
struct PageInfoResponse: Codable {
    let totalResults: Int
    let resultsPerPage: Int
    
    init(totalResults: Int = 0, resultsPerPage: Int = 0) {
        self.totalResults = totalResults
        self.resultsPerPage = resultsPerPage
    }
}
