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

    // MARK: - GET

    func get(
        for playlistId: String,
        updatedAt: TimeInterval
    ) -> YoutubePlaylist? {

        // 1️⃣ MEMORY CACHE
        if let entry = memoryCache[playlistId] {
            if entry.cachedAt >= updatedAt {
                DLog("📦 YT CACHE HIT (memory) →", playlistId)
                return entry.playlist
            } else {
                DLog("♻️ YT CACHE INVALID (memory) →", playlistId)
                memoryCache.removeValue(forKey: playlistId)
            }
        }

        // 2️⃣ DISK CACHE
        if let diskEntry =
            YoutubePlaylistDiskCache.shared.load(for: playlistId) {

            if diskEntry.cachedAt >= updatedAt {

                memoryCache[playlistId] = CacheEntry(
                    playlist: diskEntry.playlist,
                    cachedAt: diskEntry.cachedAt
                )

                DLog("📦 YT CACHE HIT (disk) →", playlistId)
                return diskEntry.playlist

            } else {
                DLog("♻️ YT CACHE INVALID (disk) →", playlistId)
                YoutubePlaylistDiskCache.shared.remove(for: playlistId)
            }
        }

        return nil
    }

    // MARK: - SET

    func set(
        _ playlist: YoutubePlaylist,
        for playlistId: String
    ) {

        let now = Date().timeIntervalSince1970

        let entry = CacheEntry(
            playlist: playlist,
            cachedAt: now
        )

        memoryCache[playlistId] = entry

        YoutubePlaylistDiskCache.shared.save(
            playlist: playlist,
            cachedAt: now,
            for: playlistId
        )

        DLog(
            "💾 YT CACHE SAVED →",
            playlistId,
            "items:",
            playlist.items.count
        )
    }

    // MARK: - INVALIDATE (Settings Sync)

    func invalidateAll() {
        memoryCache.removeAll()
        YoutubePlaylistDiskCache.shared.clearAll()
        DLog("🧹 YT CACHE CLEARED (memory + disk)")
    }
}
