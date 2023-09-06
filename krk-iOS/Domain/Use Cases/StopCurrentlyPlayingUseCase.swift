//
//  StopCurrentlyPlayingUseCase.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/4/23.
//

import Foundation

protocol StopCurrentlyPlayingUseCase {
    func execute() async throws
}

struct DefaultStopCurrentlyPlayingUseCase: StopCurrentlyPlayingUseCase {
    let repository: KaraokeRepository
    
    init(repository: KaraokeRepository) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.stopCurrentlyPlaying()
    }
}
