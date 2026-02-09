//
//  extension+CloudPlaylist.swift
//  ibvn
//
//  Created by joseletona on 31/1/26.
//

import Foundation

extension CloudPlaylist {
    var publishedDate: Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        return formatter.date(from: publishedAt) ?? .distantPast
    }
}

extension CloudPlaylist: Equatable {
    static func == (lhs: CloudPlaylist, rhs: CloudPlaylist) -> Bool {
        lhs.id == rhs.id &&
        lhs.publishedAt == rhs.publishedAt &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.thumbnailUrl == rhs.thumbnailUrl &&
        lhs.thumbnailWidth == rhs.thumbnailWidth &&
        lhs.thumbnailHeight == rhs.thumbnailHeight
    }
}
