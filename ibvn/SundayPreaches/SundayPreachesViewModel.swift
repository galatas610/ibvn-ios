//
//  SundayPreachesViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 26/3/24.
//

import Foundation

class SundayPreachesViewModel: ObservableObject {
    @Published var youtubeSearch: YoutubeSearch = .init()
    @Published var elRetoDeHoyLists: YouTubeList = .init()
    // MARK: Initialization
    init(){
        localFetchSundayPreaches()
    }
    
    
    // MARK: Functions
    func fetchElRetoDeHoyPlaylists() async {
        guard let url = URL(string: "") else {
            print("🚩 Fail ElRetoDeHoy playlist URL")
            
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
                self.elRetoDeHoyLists = try JSONDecoder().decode(YouTubeList.self, from: data)
            } catch(let error) {
                print("🚩 error: \(error)")
            }
            
            
        } catch(let error) {
            print("🚩 error: \(error)")
        }
    }
    
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
                let youtubeSearch = try JSONDecoder().decode(YouTubeList.self, from: data)
                print("🚩 youtubeSearch: \(String(describing: youtubeSearch))")
            } catch(let error) {
                print("🚩 error decoding local #ElRetoDeHoy: \(String(describing: error))")
            }
        }
    }
    
    func localFetchSundayPreaches() {
        guard let url = Bundle.main.url(forResource: "SundayPreaches", withExtension: "json") else {
            print("json file not found")
            
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("error getting Data from json")
            
            return
        }
        
        DispatchQueue.main.async {
            do {
                let youtubeSearch = try JSONDecoder().decode(YoutubeSearch.self, from: data)
                self.youtubeSearch = youtubeSearch
            } catch(let error) {
                print("🚩 error decoding #Preaches: \(String(describing: error))")
            }
        }
    }
    
    func fetchSundayPreaches() {
        let _ = "AIzaSyCTkfyhNMgKcDTlZsNZ2IT57ztfXySdl5c"
        let _ = "AIzaSyDxL4ZavnYUE0_cMWOVt_ibWoPqcfMfLSQ"
        
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyDxL4ZavnYUE0_cMWOVt_ibWoPqcfMfLSQ&channelId=UCoNq7HF7vnqalfg-lTaxrDQ&type=video&eventType=completed&part=snippet&order=date&maxResults=50") else {
            return
        }
        
        URLSession
            .shared
            .dataTask(with: url) { data, response, error in
                print("🚩 error: \(String(describing: error?.localizedDescription))")
                guard error == nil else {
                    print("🚩 error: \(String(describing: error))")
                    return
                }
                
                guard  let httpResponse = response as? HTTPURLResponse else {
                    print("🚩 httpResponse: \(String(describing: response))")
                    print("🚩 error Response: \(String(describing: response?.description))")
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("🚩 fail httpResponde StatusCode: \(httpResponse.statusCode)")
                    return
                }
                
                guard let data = data else {
                    print("🚩 fail guard data")
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        self.youtubeSearch = try JSONDecoder().decode(YoutubeSearch.self, from: data)
                        print("🚩 sundayPreaches: \(String(describing: self.youtubeSearch))")
                    } catch(let error) {
                        print("🚩 error: \(String(describing: error))")
                    }
                }
            }
            .resume()
    }
}
