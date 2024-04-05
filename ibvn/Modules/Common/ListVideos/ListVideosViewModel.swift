//
//  ListVideosViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation

final class ListVideosViewModel: ObservableObject {
    // MARK: Property Wrappers
    @Published var youtubePlaylistItems: YoutubePlaylist = .init()
    @Published var playlist: Item

    // MARK: Initialization
    init(playlist: Item) {
        self.playlist = playlist
        
        
        taskFetchListVideos()
    }
    
    // MARK: Functions
    private func taskFetchListVideos() {
        Task {
            await fetchListVideos()
        }
    }
    
    private func fetchListVideos() async {
        let playlistUrl = "https://www.googleapis.com/youtube/v3/playlistItems"
        guard let url = URL(string: playlistUrl + "?key=AIzaSyCTkfyhNMgKcDTlZsNZ2IT57ztfXySdl5c&channelId=UCoNq7HF7vnqalfg-lTaxrDQ&playlistId=" + playlist.listId.playlistId + "&part=snippet&maxResults=50") else {
            print("🚩 Fail ElRetoDeHoy playlistVideos URL")
            
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard  let httpResponse = response as? HTTPURLResponse else {
                print("🚩 httpResponse: \(String(describing: response))")
                print("🚩 error Response: \(String(describing: response.description))")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("🚩 fail httpResponde StatusCode: \(httpResponse.statusCode)")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    self.youtubePlaylistItems = try JSONDecoder().decode(YoutubePlaylist.self, from: data)
                } catch let error as NSError {
                    print("🚩 error: \(error)")
                }
            }
        } catch let error as NSError {
            print("🚩 error: \(error)")
        }
    }
}
