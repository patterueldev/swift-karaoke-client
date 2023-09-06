//
//  CancelReservedSongUseCase.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/4/23.
//

import Foundation

protocol CancelReservedSongUseCase {
    func execute(song: ReservedSong) async throws
}

struct DefaultCancelReservedSongUseCase: CancelReservedSongUseCase {
    let repository: KaraokeRepository
    
    init(repository: KaraokeRepository) {
        self.repository = repository
    }
    
    func execute(song: ReservedSong) async throws {
        try await repository.cancelReservation(song)
    }
}
