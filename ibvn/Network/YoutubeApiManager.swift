//
//  YoutubeApiManager.swift
//  ibvn
//
//  Created by Jose Letona on 13/4/24.
//

import Foundation
import Combine
import CombineMoya
import Moya

enum YoutubeApiManager {
    static private let privateKey = "AIzaSyCTkfyhNMgKcDTlZsNZ2IT57ztfXySdl5c"
    static private let channelId = "UCoNq7HF7vnqalfg-lTaxrDQ"
    
    case playlistItems(playlistId: String, pageToken: String)
    case search(eventType: String)
    case playlist(pageToken: String)
}
extension YoutubeApiManager: TargetType {
  public var baseURL: URL {
    return URL(string: "https://www.googleapis.com/youtube/v3")!
  }

  public var path: String {
    switch self {
    case .playlistItems:
        return "/playlistItems"
    case .search:
        return "/search"
    case .playlist:
        return "/playlists"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .playlistItems, .search, .playlist:
        return .get
    }
  }

  public var sampleData: Data {
    return Data()
  }
    
    public var task: Task {
        switch self {
        case .playlistItems(let playlistId, let pageToken):
            return .requestParameters(
                parameters: [
                    "key": YoutubeApiManager.privateKey,
                    "channelId": YoutubeApiManager.channelId,
                    "playlistId": playlistId,
                    "part": "snippet",
                    "pageToken": pageToken,
                    "maxResults": 50
                ],
                encoding: URLEncoding.default)
        case .search(let eventType):
            return .requestParameters(
                parameters: [
                    "key": YoutubeApiManager.privateKey,
                    "channelId": YoutubeApiManager.channelId,
                    "type": "video",
                    "order": "date",
                    "eventType": eventType,
                    "part": "snippet",
                    "maxResults": 50
                ],
                encoding: URLEncoding.default)
            
        case .playlist(let pageToken):
            return .requestParameters(
        parameters: [
            "key": YoutubeApiManager.privateKey,
            "channelId": YoutubeApiManager.channelId,
            "order": "date",
            "part": "snippet",
            "pageToken": pageToken,
            "maxResults": 50
        ],
        encoding: URLEncoding.default)
        }
    }

  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}
