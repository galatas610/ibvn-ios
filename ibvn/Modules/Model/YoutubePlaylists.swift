//
//  YoutubeSearchPlaylist.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation

// MARK: - Welcome
struct YoutubePlaylists: Codable {
    let kind: String
    let etag: String
    let regionCode: String
    let pageInfo: PageInfo
    let items: [Item]
    
    init(
        kind: String = "",
        etag: String = "",
        regionCode: String = "",
        pageInfo: PageInfo = .init(),
        items: [Item] = []
    ) {
        self.kind = kind
        self.etag = etag
        self.regionCode = regionCode
        self.pageInfo = pageInfo
        self.items = items
    }
}

// MARK: - Item
struct Item: Codable, Identifiable {
    var id = UUID()
    
    let kind: String
    let etag: String
    let listId: ListId
    let snippet: Snippet
    
    enum CodingKeys: String, CodingKey {
        case kind
        case etag
        case listId = "id"
        case snippet
    }
    
    init(kind: String = "", etag: String = "", listId: ListId = ListId(kind: "", videoId: "", playlistId: ""), snippet: Snippet = Snippet()) {
        self.kind = kind
        self.etag = etag
        self.listId = listId
        self.snippet = snippet
    }
    
}

// MARK: - ListId
struct ListId: Codable {
    let kind: String
    let videoId: String?
    let playlistId: String?
}

// MARK: - Snippet
struct Snippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let liveBroadcastContent: String
    let publishTime: String

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
    
    init(
        publishedAt: String = "2024-02-12T16:04:49Z",
         channelId: String = "UCoNq7HF7vnqalfg-lTaxrDQ",
         title: String = "Diseño Original - Hablemos de Matrimonio - El Reto de Hoy",
        description: String = "Muchos han intentado vivir el matrimonio a su propio estilo, pero el matrimonio tiene un diseño original, y ese ese le único que realmente funciona.",
        thumbnails: Thumbnails = .init(),
        channelTitle: String = "Iglesia Bautista Vida Nueva",
        liveBroadcastContent: String = "",
        publishTime: String = "2025-02-12T16:04:49Z"
    ) {
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

    init(
        `default`: ThumbnailsInfo = .init(),
        medium: ThumbnailsInfo = .init(),
        high: ThumbnailsInfo = .init()
    ) {
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
struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
    
    init(
        totalResults: Int = 0,
        resultsPerPage: Int = 0
    ) {
        self.totalResults = totalResults
        self.resultsPerPage = resultsPerPage
    }
}