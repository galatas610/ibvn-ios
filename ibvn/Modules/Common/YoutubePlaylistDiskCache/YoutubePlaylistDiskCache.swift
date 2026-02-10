//
//  YoutubePlaylistDiskCache.swift
//  ibvn
//
//  Created by joseletona on 10/2/26.
//

import Foundation

final class YoutubePlaylistDiskCache {

    static let shared = YoutubePlaylistDiskCache()

    private let folderURL: URL

    private init() {
        let baseURL = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first!

        folderURL = baseURL.appendingPathComponent(
            "youtube-playlists",
            isDirectory: true
        )

        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try? FileManager.default.createDirectory(
                at: folderURL,
                withIntermediateDirectories: true
            )
        }
    }

    // MARK: - Save

    func save(_ playlist: YoutubePlaylist, for playlistId: String) {
        let fileURL = fileURLForPlaylist(id: playlistId)

        do {
            let data = try JSONEncoder().encode(playlist)
            try data.write(to: fileURL, options: .atomic)
            DLog("💽 YT DISK SAVED → playlist:", playlistId)
        } catch {
            DLog("❌ YT DISK SAVE ERROR →", error.localizedDescription)
        }
    }

    // MARK: - Load

    func load(for playlistId: String) -> YoutubePlaylist? {
        let fileURL = fileURLForPlaylist(id: playlistId)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let playlist = try JSONDecoder().decode(
                YoutubePlaylist.self,
                from: data
            )
            DLog("💽 YT DISK HIT → playlist:", playlistId)
            return playlist
        } catch {
            DLog("❌ YT DISK LOAD ERROR →", error.localizedDescription)
            return nil
        }
    }

    // MARK: - Clear

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
