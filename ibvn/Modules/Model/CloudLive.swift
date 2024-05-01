//
//  CloudLive.swift
//  ibvn
//
//  Created by Jose Letona on 10/4/24.
//

import Foundation

struct CloudLive: Encodable {
    let videoId: String
    
    init(videoId: String = "") {
        self.videoId = videoId
    }
}
