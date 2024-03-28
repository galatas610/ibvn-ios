//
//  YoutubeListVideos.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import Foundation

// MARK: - Welcome
struct YoutubeListVideos: Codable {
    let kind, etag: String
    let items: [ListVideosItem]
    let pageInfo: PageInfo
    
    init(
        kind: String = "",
        etag: String = "",
        items: [ListVideosItem] = [],
        pageInfo: PageInfo = .init()
    ) {
        self.kind = kind
        self.etag = etag
        self.items = items
        self.pageInfo = pageInfo
    }
}

// MARK: - Item
struct ListVideosItem: Codable {
    let kind, etag, id: String
    let snippet: SnippetList
}

// MARK: - Snippet
struct SnippetList: Codable {
    let publishedAt: String
    let channelID, title, description: String
    let thumbnails: ThumbnailsList
    let channelTitle, playlistID: String
    let position: Int
    let resourceID: ResourceID
    let videoOwnerChannelTitle, videoOwnerChannelID: String?

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title, description, thumbnails, channelTitle
        case playlistID = "playlistId"
        case position
        case resourceID = "resourceId"
        case videoOwnerChannelTitle
        case videoOwnerChannelID = "videoOwnerChannelId"
    }
}

// MARK: - ResourceID
struct ResourceID: Codable {
    let kind, videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

// MARK: - Thumbnails
struct ThumbnailsList: Codable {
    let thumbnailsDefault, medium, high, standard: ThumbnailsInfo?
    let maxres: ThumbnailsInfo?

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high, standard, maxres
    }
}
/*
// MARK: - Default
struct Default: Codable {
    let url: String
    let width, height: Int
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
*/
