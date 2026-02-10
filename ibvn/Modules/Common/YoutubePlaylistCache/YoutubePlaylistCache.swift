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

    private var memoryCache: [String: CacheEntry] = [:]

    // MARK: - Get

    func get(
        for playlistId: String,
        updatedAt: TimeInterval
    ) -> YoutubePlaylist? {

        // 1️⃣ Memory cache
        if let entry = memoryCache[playlistId] {
            if entry.cachedAt >= updatedAt {
                DLog("📦 YT CACHE HIT (memory) →", playlistId)
                return entry.playlist
            } else {
                DLog("♻️ YT CACHE INVALID (memory) →", playlistId)
                memoryCache.removeValue(forKey: playlistId)
            }
        }

        // 2️⃣ Disk cache
        if let diskPlaylist =
            YoutubePlaylistDiskCache.shared.load(for: playlistId) {

            let now = Date().timeIntervalSince1970
            memoryCache[playlistId] = CacheEntry(
                playlist: diskPlaylist,
                cachedAt: now
            )

            DLog("📦 YT CACHE HIT (disk → memory) →", playlistId)
            return diskPlaylist
        }

        return nil
    }

    // MARK: - Set

    func set(_ playlist: YoutubePlaylist, for playlistId: String) {
        let now = Date().timeIntervalSince1970

        memoryCache[playlistId] = CacheEntry(
            playlist: playlist,
            cachedAt: now
        )

        YoutubePlaylistDiskCache.shared.save(
            playlist,
            for: playlistId
        )

        DLog(
            "💾 YT CACHE SAVED →",
            playlistId,
            "items:",
            playlist.items.count
        )
    }

    // MARK: - Invalidate (used by Settings sync)

    func invalidateAll() {
        memoryCache.removeAll()
        YoutubePlaylistDiskCache.shared.clearAll()
        DLog("🧹 YT CACHE CLEARED (mem + disk)")
    }
}
