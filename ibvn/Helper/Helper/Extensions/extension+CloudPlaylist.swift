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
