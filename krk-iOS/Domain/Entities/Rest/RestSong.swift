//
//  RestSong.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

struct RestSong: Song, Codable {
    let identifier: String
    let title: String
    let artist: String?
    let image: String?
    let containsLyrics: Bool
    let containsVoice: Bool
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case title
        case artist
        case image
        case containsLyrics
        case containsVoice
    }
}
