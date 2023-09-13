//
//  YoutubeSearchResults.swift
//  Netflix
//
//  Created by Mohamed Ismail on 03/09/2023.
//

import Foundation

struct YoutubeSearchResults: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
