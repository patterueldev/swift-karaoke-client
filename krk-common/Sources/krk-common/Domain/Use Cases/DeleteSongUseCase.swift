//
//  File.swift
//
//
//  Created by John Patrick Teruel on 2/8/24.
//

import Foundation

public protocol DeleteSongUseCase {
    func execute(song: Song) async throws
}

struct DefaultDeleteSongUseCase: DeleteSongUseCase {
    let repository: KaraokeRepository
    
    init(repository: KaraokeRepository) {
        self.repository = repository
    }
    
    func execute(song: Song) async throws {
        try await repository.deleteSong(song)
    }
}
