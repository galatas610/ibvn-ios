//
//  ListVideosViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation
import Moya

final class ListVideosViewModel: ObservableObject, PresentAlertType {
    // MARK: Property Wrappers
    @Published var youtubePlaylistItems: YoutubePlaylistTMP = .init()
    @Published var playlist: Item
    @Published var showAlertDecodeError: Bool = false
    @Published var showRequestError: Bool = false
    @Published var alertInfo: AlertInfo?
    @Published var alertIsPresenting: Bool = false
    
    // MARK: Initialization
    init(playlist: Item) { self.playlist = playlist }
    
    // MARK: Functions
    private func fetchYoutubePlaylistItems(playlistId: String) {
        let provider = MoyaProvider<YoutubeApiManager>()
        
        provider.request(.playlistItems(playlistId: playlistId)) { result in
            switch result {
            case let .success(response):
                do {
                    self.youtubePlaylistItems = try JSONDecoder().decode(YoutubePlaylistTMP.self, from: response.data)
                } catch {
                    self.displayError(error)
                }
            case let .failure(error):
                self.displayError(error)
            }
        }
    }
    
    func fetchYoutubePlaylistItems() {
        fetchYoutubePlaylistItems(playlistId: playlist.listId.playlistId ?? "")
    }
}
