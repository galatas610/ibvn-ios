//
//  LiveCloud.swift
//  ibvn
//
//  Created by Jose Letona on 10/4/24.
//

import Foundation

struct LiveCloud: Encodable {
    let videoId: String
    
    init(videoId: String = "") {
        self.videoId = videoId
    }
}
