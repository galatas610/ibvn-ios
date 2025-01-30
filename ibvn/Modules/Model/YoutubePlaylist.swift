//
//  YoutubeList.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import Foundation

// MARK: - YoutubePlaylist
struct YoutubePlaylist: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String?
    let prevPageToken: String?
    var items: [ListVideosItem]
    let pageInfo: PageInfo
    
    init(
        kind: String = "",
        etag: String = "",
        nextPageToken: String = "",
        prevPageToken: String = "",
        items: [ListVideosItem] = [],
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
struct ListVideosItem: Codable {
    let kind: String
    let etag: String
    let id: String
    let snippet: SnippetList
}

// MARK: - Snippet
struct SnippetList: Codable {
    let publishedAt: String
    let channelID: String
    let title: String
    let description: String
    let thumbnails: ThumbnailsList
    let channelTitle: String
    let playlistID: String
    let position: Int
    let resourceID: ResourceID
    let videoOwnerChannelTitle: String?
    let videoOwnerChannelID: String?

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case description
        case thumbnails
        case channelTitle
        case playlistID = "playlistId"
        case position
        case resourceID = "resourceId"
        case videoOwnerChannelTitle
        case videoOwnerChannelID = "videoOwnerChannelId"
    }
}

// MARK: - ResourceID
struct ResourceID: Codable {
    let kind: String
    let videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

// MARK: - Thumbnails
struct ThumbnailsList: Codable {
    let thumbnailsDefault: Thumbnails?
    let medium: Thumbnails?
    let high: Thumbnails?
    let standard: Thumbnails?
    let maxres: Thumbnails?

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium
        case high
        case standard
        case maxres
    }
}
// MARK: - Default
struct Thumbnails: Codable {
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
