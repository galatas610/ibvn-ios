//
//  YouTubeList.swift
//  ibvn
//
//  Created by Jose Letona on 27/3/24.
//

import Foundation

// MARK: - YoutubeSearch
struct YouTubeList: Codable, Identifiable {
    let id = UUID()
    let kind, etag, nextPageToken: String
    let pageInfo: PageInfo
    let items: [ListItem]
    
    init(kind: String = "",
         etag: String = "",
         nextPageToken: String = "",
         pageInfo: PageInfo = .init(),
         items: [ListItem] = []) {
        self.kind = kind
        self.etag = etag
        self.nextPageToken = nextPageToken
        self.pageInfo = pageInfo
        self.items = items
    }
    
    enum CodingKeys: CodingKey {
        case kind
        case etag
        case nextPageToken
        case pageInfo
        case items
    }
}

// MARK: - Item
struct ListItem: Codable, Identifiable {
    let kind: String
    let etag, id: String
    let snippet: Snippet
    
    enum CodingKeys: String, CodingKey {
        case kind
        case etag
        case id
        case snippet
    }
}
