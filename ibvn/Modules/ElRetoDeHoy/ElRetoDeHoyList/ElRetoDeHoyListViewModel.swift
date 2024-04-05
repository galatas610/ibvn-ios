//
//  ElRetoDeHoyListViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import Foundation

class ElRetoDeHoyListViewModel: ObservableObject {
    @Published var elRetoDeHoyLists: SearchPlaylist = .init()
    // MARK: Initialization
    init() { }
    
    // MARK: Functions
//    func fetchElRetoDeHoyPlaylists() async {
//        let apiSeachListBaseUrl: String = "https://www.googleapis.com/youtube/v3/playlists"
//        let apiKey: String = "AIzaSyCTkfyhNMgKcDTlZsNZ2IT57ztfXySdl5c"
//        let channelId: String = "UCoNq7HF7vnqalfg-lTaxrDQ"
//        
//        guard let url = URL(string: apiSeachListBaseUrl + "?key=" + apiKey + "&channelId=" + channelId + "&type=playlist&order=date&part=snippet&q=el+reto+de+hoy&maxResults=50") else {
//            print("🚩 Fail ElRetoDeHoy playlist URL")
//            
//            return
//        }
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            
//            guard  let httpResponse = response as? HTTPURLResponse else {
//                print("🚩 httpResponse: \(String(describing: response))")
//                print("🚩 error Response: \(String(describing: response.description))")
//                return
//            }
//            
//            guard httpResponse.statusCode == 200 else {
//                print("🚩 fail httpResponde StatusCode: \(httpResponse.statusCode)")
//                return
//            }
//            
//            do {
//                self.elRetoDeHoyLists = try JSONDecoder().decode(YouTubeList.self, from: data)
//            } catch let error as NSError {
//                print("🚩 error: \(error)")
//            }
//        } catch let error as NSError {
//            print("🚩 error: \(error)")
//        }
//    }
    
    // TODO: remove localFetchElRetoDeHoyPlaylists and Local data ElRetoDeHoyLists
    func localFetchElRetoDeHoyPlaylists() {
        guard let url = Bundle.main.url(forResource: "ElRetoDeHoyLists", withExtension: "json") else {
            print("json file not found")
            
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("error getting Data from json")
            
            return
        }
        
        DispatchQueue.main.async {
            do {
                let elRetoDeHoyLists = try JSONDecoder().decode(SearchPlaylist.self, from: data)
                print("🚩 elRetoDeHoyLists: \(String(describing: elRetoDeHoyLists))")
                self.elRetoDeHoyLists = elRetoDeHoyLists
            } catch let error as NSError {
                print("🚩 error decoding local #ElRetoDeHoy: \(String(describing: error))")
            }
        }
    }
}
