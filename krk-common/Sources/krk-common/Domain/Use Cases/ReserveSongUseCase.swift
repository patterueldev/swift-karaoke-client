//
//  ReserveSongUseCase.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

public protocol ReserveSongUseCase {
    func execute(song: Song) async throws
}

struct DefaultReserveSongUseCase: ReserveSongUseCase {
    let repository: KaraokeRepository
    
    init(repository: KaraokeRepository) {
        self.repository = repository
    }
    
    func execute(song: Song) async throws {
        try await repository.reserveSong(song)
    }
}
