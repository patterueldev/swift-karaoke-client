//
//  GetReservedSongsUseCase.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

public protocol GetReservedSongsUseCase {
    func execute() async throws -> [ReservedSong]
}

struct DefaultGetReservedSongsUseCase: GetReservedSongsUseCase {
    let repository: KaraokeRepository
    
    init(repository: KaraokeRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [ReservedSong] {
        return try await repository.getReservedSongs()
    }
}
