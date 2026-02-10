//
//  CloudLive.swift
//  ibvn
//
//  Created by Jose Letona on 10/4/24.
//

import Foundation

struct CloudLive: Encodable {
    let videoId: String
    let title: String
    let thumbnail: String
    let state: LiveState
    let isLive: Bool
    let publishedAt: String
    let description: String

    init(
        videoId: String = "",
        title: String = "",
        thumbnail: String = "",
        state: LiveState = .last,
        isLive: Bool = false,
        publishedAt: String = "",
        description: String = ""
    ) {
        self.videoId = videoId
        self.title = title
        self.thumbnail = thumbnail
        self.state = state
        self.isLive = isLive
        self.publishedAt = publishedAt
        self.description = description
    }
}

enum LiveState: String, Encodable {
    case live
    case upcoming
    case last
}
