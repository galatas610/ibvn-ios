//
//  ElRetoDeHoyListViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import Foundation

class ElRetoDeHoyListViewModel: ObservableObject {
    @Published var elRetoDeHoyLists: YoutubeSearchPlaylist = .init()
    // MARK: Initialization
    init() { }
    
    // MARK: Functions
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
                let elRetoDeHoyLists = try JSONDecoder().decode(YoutubeSearchPlaylist.self, from: data)
                print("🚩 elRetoDeHoyLists: \(String(describing: elRetoDeHoyLists))")
                self.elRetoDeHoyLists = elRetoDeHoyLists
            } catch let error as NSError {
                print("🚩 error decoding local #ElRetoDeHoy: \(String(describing: error))")
            }
        }
    }
}
