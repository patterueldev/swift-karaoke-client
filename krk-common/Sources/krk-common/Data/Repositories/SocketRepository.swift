//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/6/23.
//

import Foundation

protocol SocketRepository {
    func observeReservedSongs() -> AsyncStream<[ReservedSong]>
}
