//
//  KoinoniaViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import Foundation

final class KoinoniaViewModel: ObservableObject {
    @Published var koinoniaVideos: YoutubeSearch = .init()
    // MARK: Initialization
    init() {
        localFetchkoinoniaVideos()
    }
    
    // MARK: Functions
    func localFetchkoinoniaVideos() {
        guard let url = Bundle.main.url(forResource: "Koinonia", withExtension: "json") else {
            print("Koinonia json file not found")
            
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Koinonia error getting Data from json")
            
            return
        }
        
        DispatchQueue.main.async {
            do {
                let koinoniaVideos = try JSONDecoder().decode(YoutubeSearch.self, from: data)
                self.koinoniaVideos = koinoniaVideos
            } catch let error as NSError {
                print("🚩 Koinonia error decoding #Preaches: \(String(describing: error))")
            }
        }
    }
    
    func fetchSundayPreaches() {
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyDxL4ZavnYUE0_cMWOVt_ibWoPqcfMfLSQ&channelId=UCoNq7HF7vnqalfg-lTaxrDQ&type=video&order=date&part=snippet&maxResults=50&q=Koinonia") else {
            return
        }
        
        URLSession
            .shared
            .dataTask(with: url) { data, response, error in
                print("🚩 Koinonia error: \(String(describing: error?.localizedDescription))")
                guard error == nil else {
                    print("🚩 Koinonia error: \(String(describing: error))")
                    return
                }
                
                guard  let httpResponse = response as? HTTPURLResponse else {
                    print("🚩 Koinonia httpResponse: \(String(describing: response))")
                    print("🚩 Koinonia error Response: \(String(describing: response?.description))")
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("🚩 Koinonia fail httpResponde StatusCode: \(httpResponse.statusCode)")
                    return
                }
                
                guard let data = data else {
                    print("🚩 Koinonia fail guard data")
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        self.koinoniaVideos = try JSONDecoder().decode(YoutubeSearch.self, from: data)
                        print("🚩 Koinonia sundayPreaches: \(String(describing: self.koinoniaVideos))")
                    } catch let error as NSError {
                        print("🚩 Koinonia error: \(String(describing: error))")
                    }
                }
            }
            .resume()
    }
}
