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
    // MARK: Variables
    private var listId: String
    
    var snippet: Snippet
    
    // MARK: Initialization
    init(listId: String, snippet: Snippet) {
        self.listId = listId
        self.snippet = snippet
    }
    
    // MARK: Functions
    func fetchElRetoDeHoyPlaylistsVideos() async {
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?key=AIzaSyCTkfyhNMgKcDTlZsNZ2IT57ztfXySdl5c&channelId=UCoNq7HF7vnqalfg-lTaxrDQ&playlistId="+listId+"&part=snippet") else {
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
            
            do {
                self.elRetoDeHoyListVideos = try JSONDecoder().decode(YoutubeListVideos.self, from: data)
            } catch(let error) {
                print("🚩 error: \(error)")
            }
            
            
        } catch(let error) {
            print("🚩 error: \(error)")
        }
    }
    
    func localFetchVideosFromList() {
        guard let url = Bundle.main.url(forResource: "ElRetoDeHoyVideos", withExtension: "json") else {
            print("json file not found")
            
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("error getting Data from json")
            
            return
        }
        
        DispatchQueue.main.async {
            do {
                let elRetoDeHoyListVideos = try JSONDecoder().decode(YoutubeListVideos.self, from: data)
                print("🚩 elRetoDeHoyListVideos: \(String(describing: elRetoDeHoyListVideos))")
                self.elRetoDeHoyListVideos = elRetoDeHoyListVideos
            } catch(let error) {
                print("🚩 error decoding local #ElRetoDeHoyVideos: \(String(describing: error))")
            }
        }
    }
}
