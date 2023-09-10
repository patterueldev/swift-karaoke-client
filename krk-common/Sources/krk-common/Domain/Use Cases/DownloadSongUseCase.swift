//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/10/23.
//

import Foundation

public protocol DownloadSongUseCase {
    func execute(parameter: DownloadSongParameter) async throws -> Song
}

struct DefaultDownloadSongUseCase: DownloadSongUseCase {
    private let repository: KaraokeRepository
    
    init(repository: KaraokeRepository) {
        self.repository = repository
    }
    
    func execute(parameter: DownloadSongParameter) async throws -> Song {
        try await self.repository.downloadSong(parameter)
    }
}
