//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/6/23.
//

import Foundation

public protocol ObserveReservedSongsUseCase {
    func observe() -> AsyncStream<[ReservedSong]>
}

struct DefaultObserveReservedSongsUseCase: ObserveReservedSongsUseCase {
    let socketRepository: SocketRepository
    init(socketRepository: SocketRepository) {
        self.socketRepository = socketRepository
    }
    
    func observe() -> AsyncStream<[ReservedSong]> {
        socketRepository.observeReservedSongs()
    }
}

