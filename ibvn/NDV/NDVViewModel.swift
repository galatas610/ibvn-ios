//
//  NDVViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 28/3/24.
//

import Foundation

class NDVViewModel: ObservableObject {
    @Published var ndvVideos: YoutubeSearch = .init()
    // MARK: Initialization
    init(){
        localFetchNocheDeViernesVideos()
    }
    
    // MARK: Functions
    func localFetchNocheDeViernesVideos() {
        guard let url = Bundle.main.url(forResource: "NocheDeViernes", withExtension: "json") else {
            print("NDV json file not found")
            
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("NDV error getting Data from json")
            
            return
        }
        
        DispatchQueue.main.async {
            do {
                let ndvVideos = try JSONDecoder().decode(YoutubeSearch.self, from: data)
                self.ndvVideos = ndvVideos
            } catch(let error) {
                print("🚩 NDV error decoding #Preaches: \(String(describing: error))")
            }
        }
    }
    
    func fetchSundayPreaches() {
        let _ = "AIzaSyCTkfyhNMgKcDTlZsNZ2IT57ztfXySdl5c"
        let _ = "AIzaSyDxL4ZavnYUE0_cMWOVt_ibWoPqcfMfLSQ"
        
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/search?key=AIzaSyDxL4ZavnYUE0_cMWOVt_ibWoPqcfMfLSQ&channelId=UCoNq7HF7vnqalfg-lTaxrDQ&type=video&order=date&part=snippet&maxResults=50&q=%23NDV") else {
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
                        self.ndvVideos = try JSONDecoder().decode(YoutubeSearch.self, from: data)
                        print("🚩 sundayPreaches: \(String(describing: self.ndvVideos))")
                    } catch(let error) {
                        print("🚩 error: \(String(describing: error))")
                    }
                }
            }
            .resume()
    }
}
