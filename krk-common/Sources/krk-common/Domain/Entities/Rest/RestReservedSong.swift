//
//  RestReservedSong.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation


struct RestReservedSong: ReservedSong, Codable {
    let identifier: String
    let restSong: RestSong
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case restSong = "song"
    }
    
    var song: Song {
        return restSong
    }
}
