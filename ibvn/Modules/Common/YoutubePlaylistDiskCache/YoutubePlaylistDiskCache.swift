//
//  YoutubePlaylistDiskCache.swift
//  ibvn
//
//  Created by joseletona on 10/2/26.
//

import Foundation

final class YoutubePlaylistDiskCache {
    static let shared = YoutubePlaylistDiskCache()
    
    // MARK: - Disk Entry
    struct DiskEntry: Codable {
        let playlist: YoutubePlaylist
        let cachedAt: TimeInterval
    }
    
    private let folderURL: URL
    
    private init() {
        let fileManager = FileManager.default

        if let cachesURL = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first {

            folderURL = cachesURL.appendingPathComponent(
                "youtube-playlists",
                isDirectory: true
            )
        } else {
            // Fallback ultra defensivo (no debería pasar nunca)
            folderURL = fileManager.temporaryDirectory.appendingPathComponent(
                "youtube-playlists",
                isDirectory: true
            )
            DLog("⚠️ YT DISK CACHE → using temporaryDirectory fallback")
        }

        do {
            if !fileManager.fileExists(atPath: folderURL.path) {
                try fileManager.createDirectory(
                    at: folderURL,
                    withIntermediateDirectories: true
                )
            }
        } catch {
            DLog("❌ YT DISK CACHE INIT ERROR →", error.localizedDescription)
        }
    }
    
    // MARK: - Save
    
    func save(
        playlist: YoutubePlaylist,
        cachedAt: TimeInterval,
        for playlistId: String
    ) {
        
        let entry = DiskEntry(
            playlist: playlist,
            cachedAt: cachedAt
        )
        
        let fileURL = fileURLForPlaylist(id: playlistId)
        
        do {
            let data = try JSONEncoder().encode(entry)
            try data.write(to: fileURL, options: .atomic)
            DLog("💽 YT DISK SAVED →", playlistId)
        } catch {
            DLog("❌ YT DISK SAVE ERROR →", error.localizedDescription)
        }
    }
    
    // MARK: - Load
    
    func load(for playlistId: String) -> DiskEntry? {
        let fileURL = fileURLForPlaylist(id: playlistId)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let entry = try JSONDecoder().decode(DiskEntry.self, from: data)
            
            DLog("💽 YT DISK HIT →", playlistId)
            
            return entry
        } catch {
            DLog("❌ YT DISK LOAD ERROR →", error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Remove single
    func remove(for playlistId: String) {
        let fileURL = fileURLForPlaylist(id: playlistId)
        
        try? FileManager.default.removeItem(at: fileURL)
        
        DLog("🗑️ YT DISK REMOVED →", playlistId)
    }
    
    // MARK: - Clear all
    func clearAll() {
        do {
            if FileManager.default.fileExists(atPath: folderURL.path) {
                try FileManager.default.removeItem(at: folderURL)
            }
            
            try FileManager.default.createDirectory(
                at: folderURL,
                withIntermediateDirectories: true
            )
            
            DLog("🧹 YT DISK CLEARED")
        } catch {
            DLog("❌ YT DISK CLEAR ERROR →", error.localizedDescription)
        }
    }
    
    // MARK: - Helpers
    private func fileURLForPlaylist(id: String) -> URL {
        folderURL.appendingPathComponent("\(id).json")
    }
}
