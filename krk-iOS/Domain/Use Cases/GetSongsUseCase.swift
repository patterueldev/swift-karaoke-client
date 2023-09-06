//
//  GetSongListUseCase.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation

protocol GetSongsUseCase {
    func execute(limit: Int?, offset: Int?, filter: String?) async throws -> [Song]
}

struct DefaultGetSongsUseCase: GetSongsUseCase {
    let repository: KaraokeRepository
    
    init(repository: KaraokeRepository) {
        self.repository = repository
    }
    
    func execute(limit: Int?, offset: Int?, filter: String?) async throws -> [Song] {
        return try await repository.getSongList(
            limit: limit,
            offset: offset,
            filter: filter
        )
    }
}


