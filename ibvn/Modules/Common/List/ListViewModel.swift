//
//  ListViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation

final class ListViewModel: ObservableObject {
    // MARK: Property Wrappers
    @Published var youtubePlaylists: YoutubePlaylists = .init()
    
    // MARK: Propertes
    let ibvnType: IbvnType
    
    // MARK: Initialization
    init(ibvnType: IbvnType) {
        self.ibvnType = ibvnType
       
        localFetchElRetoDeHoyPlaylists()
    }
    
    // MARK: Functions
    func localFetchElRetoDeHoyPlaylists() {
        guard let url = Bundle.main.url(forResource: ibvnType.localDataFileName, withExtension: "json") else {
            print("json file not found")
            
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("error getting Data from json")
            
            return
        }
        
        DispatchQueue.main.async {
            do {
                let youtubePlaylists = try JSONDecoder().decode(YoutubePlaylists.self, from: data)
//                print("🚩 elRetoDeHoyLists: \(String(describing: youtubePlaylists))")
                self.youtubePlaylists = youtubePlaylists
            } catch let error as NSError {
                print("🚩 error decoding local #ElRetoDeHoy: \(String(describing: error))")
            }
        }
    }
}
