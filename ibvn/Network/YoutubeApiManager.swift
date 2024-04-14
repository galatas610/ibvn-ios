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
    
    case playlistItems(playlistId: String)
}
extension YoutubeApiManager: TargetType {
  public var baseURL: URL {
    return URL(string: "https://www.googleapis.com/youtube/v3")!
  }

  public var path: String {
    switch self {
    case .playlistItems:
        return "/playlistItems"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .playlistItems:
        return .get
    }
  }

  public var sampleData: Data {
    return Data()
  }
    
    public var task: Task {
        switch self {
        case .playlistItems(let playlistId):
            return .requestParameters(
                parameters: [
                    "key": YoutubeApiManager.privateKey,
                    "channelId": YoutubeApiManager.channelId,
                    "playlistId": playlistId,
                    "part": "snippet",
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
