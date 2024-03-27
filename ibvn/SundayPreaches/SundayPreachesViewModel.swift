//
//  SundayPreachesViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 26/3/24.
//

import Foundation

class SundayPreachesViewModel: ObservableObject {
    @Published var youtubeSearch: YoutubeSearch = .init()
    @Published var videoTest: String = ""
    // MARK: Initialization
    init(){
        localFetchSundayPreaches()
    }
    
    // MARK: Functions
    
    private func localFetchSundayPreaches() {
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
//                print("🚩 youtubeSearch: \(String(describing: self.youtubeSearch))")
            } catch(let error) {
                print("🚩 error: \(String(describing: error))")
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
                        self.videoTest = self.youtubeSearch.items.first?.id.videoId ?? ""
                        print("🚩 sundayPreaches: \(String(describing: self.youtubeSearch))")
                        print("🚩 videoTest: \(String(describing: self.videoTest))")
                    } catch(let error) {
                        print("🚩 error: \(String(describing: error))")
                    }
                }
            }
            .resume()
    }
}

// MARK: - YoutubeSearch
struct YoutubeSearch: Codable {
    let kind: String
    let etag: String
//    let nextPageToken: String?
    let regionCode: String
    let pageInfo: PageInfo
    let items: [Item]
    
    init(kind: String = "",
         etag: String = "",
//         nextPageToken: String? = "",
         regionCode: String = "",
         pageInfo: PageInfo = .init(),
         items: [Item] = []) {
        self.kind = kind
        self.etag = etag
//        self.nextPageToken = nextPageToken
        self.regionCode = regionCode
        self.pageInfo = pageInfo
        self.items = items
    }
}

// MARK: - Item
struct Item: Codable {
    let kind: String
    let etag: String
    let id: ID
    let snippet: Snippet
    
    enum CodingKeys: String, CodingKey {
        case kind
        case etag
        case id
        case snippet
    }
}

// MARK: - ID
struct ID: Codable {
    let kind: String
    let videoId: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoId
    }
}

// MARK: - Snippet
struct Snippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let liveBroadcastContent: LiveBroadcastContent
    let publishTime: String

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelId
        case title
        case description
        case thumbnails
        case channelTitle
        case liveBroadcastContent
        case publishTime
    }
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let `default`: ThumbnailsInfo
    let medium: ThumbnailsInfo
    let high: ThumbnailsInfo

    enum CodingKeys: String, CodingKey {
        case `default`
        case medium
        case high
    }
}

// MARK: - Default
struct ThumbnailsInfo: Codable {
    let url: String
    let width: Int
    let height: Int
}

enum LiveBroadcastContent: String, Codable {
    case none = "none"
}


// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
    
    init(totalResults: Int = 0, resultsPerPage: Int = 0) {
        self.totalResults = totalResults
        self.resultsPerPage = resultsPerPage
    }
}
