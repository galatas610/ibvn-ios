//
//  ElRetoDeHoyVideosViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import Foundation

final class ElRetoDeHoyVideosViewModel: ObservableObject {
    // MARK: Property Wrappers
    @Published var elRetoDeHoyListVideos: YoutubeListVideos = .init()
    @Published var snippet: Snippet
    // MARK: Variables
    private var listId: String

    // MARK: Initialization
    init(listId: String, snippet: Snippet) {
        self.listId = listId
        self.snippet = snippet
    }
    
    // MARK: Functions
    func fetchElRetoDeHoyPlaylistsVideos() async {
        let playlistUrl = "https://www.googleapis.com/youtube/v3/playlistItems"
        guard let url = URL(string: playlistUrl + "?key=AIzaSyCTkfyhNMgKcDTlZsNZ2IT57ztfXySdl5c&channelId=UCoNq7HF7vnqalfg-lTaxrDQ&playlistId=" + listId + "&part=snippet") else {
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
                    self.elRetoDeHoyListVideos = try JSONDecoder().decode(YoutubeListVideos.self, from: data)
                } catch let error as NSError {
                    print("🚩 error: \(error)")
                }
            }
        } catch let error as NSError {
            print("🚩 error: \(error)")
        }
    }
}
