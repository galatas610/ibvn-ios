//
//  ListViewModel.swift
//  ibvn
//
//  Created by Jose Letona on 5/4/24.
//

import Foundation

final class ListViewModel: ObservableObject {
    // MARK: Property Wrappers
    @Published var youtubePlaylists: YoutubePlaylistsTMP = .init()
    
    // MARK: Propertes
    let ibvnType: IbvnType
    
    // MARK: Initialization
    init(ibvnType: IbvnType) {
        self.ibvnType = ibvnType
    }
    
    // MARK: Functions
}
