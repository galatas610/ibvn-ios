//
//  YoutubePlaylistCache.swift
//  ibvn
//
//  Created by joseletona on 9/2/26.
//

import Foundation

final class YoutubePlaylistCache {

    static let shared = YoutubePlaylistCache()

    private struct CacheEntry {
        let playlist: YoutubePlaylist
        let cachedAt: TimeInterval
    }

    private var cache: [String: CacheEntry] = [:]

    func get(for playlistId: String, updatedAt: TimeInterval) -> YoutubePlaylist? {
        guard let entry = cache[playlistId] else { return nil }

        if entry.cachedAt >= updatedAt {
            DLog("📦 YT CACHE HIT → playlist:", playlistId)
            return entry.playlist
        } else {
            DLog("♻️ YT CACHE INVALID → playlist:", playlistId)
            cache.removeValue(forKey: playlistId)
            return nil
        }
    }

    func set(_ playlist: YoutubePlaylist, for playlistId: String) {
        cache[playlistId] = CacheEntry(
            playlist: playlist,
            cachedAt: Date().timeIntervalSince1970
        )

        DLog("💾 YT CACHE SAVED → playlist:", playlistId, "items:", playlist.items.count)
    }
    
    func invalidateAll() {
        cache.removeAll()
        DLog("🧹 YT CACHE CLEARED (manual sync)")
    }
}
