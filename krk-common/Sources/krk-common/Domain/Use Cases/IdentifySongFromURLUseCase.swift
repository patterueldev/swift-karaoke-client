//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/10/23.
//

import Foundation

public protocol IdentifySongFromURLUseCase {
    func execute(url: String) async throws -> Song
}

class DefaultIdentifySongFromURLUseCase: IdentifySongFromURLUseCase {
    private let karaokeRepository: KaraokeRepository
    
    init(karaokeRepository: KaraokeRepository) {
        self.karaokeRepository = karaokeRepository
    }
    
    func execute(url: String) async throws -> Song {
        return try await karaokeRepository.identifySong(from: url)
    }
}

