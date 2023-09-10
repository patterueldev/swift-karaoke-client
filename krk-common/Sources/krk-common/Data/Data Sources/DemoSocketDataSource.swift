//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/6/23.
//

import Foundation

class DemoSocketDataSource: SocketRepository {
    let karaokeRepository: KaraokeRepository
    init(karaokeRepository: KaraokeRepository) {
        self.karaokeRepository = karaokeRepository
    }
    
    func observeReservedSongs() -> AsyncStream<[ReservedSong]> {
        return AsyncStream { continuation in
            Task {
                let reserved = try await karaokeRepository.getReservedSongs()
                continuation.yield(reserved)
            }
        }
    }
    
    func observeServerCommands() -> AsyncStream<Command> {
        return AsyncStream { continuation in
            Task {
                continuation.yield(.play(id: ""))
            }
        }
    }
}
