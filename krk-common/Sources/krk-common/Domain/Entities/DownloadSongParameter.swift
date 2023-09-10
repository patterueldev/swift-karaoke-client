//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/10/23.
//

import Foundation

public struct DownloadSongParameter: Song, Codable {
    public let identifier: String
    public let title: String
    public let artist: String?
    public let image: String?
    public let containsLyrics: Bool
    public let containsVoice: Bool
    public let language: String?
    public let source: String
    
    public init(identifier: String, title: String, artist: String?, image: String?, containsLyrics: Bool, containsVoice: Bool, language: String?, source: String) {
        self.identifier = identifier
        self.title = title
        self.artist = artist
        self.image = image
        self.containsLyrics = containsLyrics
        self.containsVoice = containsVoice
        self.language = language
        self.source = source
    }
}
