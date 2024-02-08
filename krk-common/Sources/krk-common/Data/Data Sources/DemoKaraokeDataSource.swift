//
//  DemoKaraokeDataSource.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation

private func notImplemented() -> Error {
    NSError(domain: "DemoKaraokeDataSource", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "Not implemented"
    ])
}


class DemoKaraokeDataSource: KaraokeRepository {
    var someSongs: [Song] = [
        DemoSong(identifier: "64f4752dbc2f36acb2c0ae6d", title: "Song 1", artist: "Artist 1", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "64f4752dbc2f36acb2c0ae6e", title: "Song 2", artist: "Artist 2", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "64f4752dbc2f36acb2c0aec7", title: "Song 3", artist: "Artist 3", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "64f4752dbc2f36acb2c0ae9a", title: "Never Gonna Give You Up", artist: "Rick Astley", image: "https://variety.com/wp-content/uploads/2021/07/Rick-Astley-Never-Gonna-Give-You-Up.png?w=1024", containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "64f4752dbc2f36acb2c0ae75", title: "Song 5", artist: "Artist 5", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "64f4752dbc2f36acb2c0ae83", title: "Song 6", artist: "Artist 6", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "64f4752dbc2f36acb2c0aebc", title: "Song 7", artist: "Artist 7", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "64f4752dbc2f36acb2c0ae6c", title: "Song 8", artist: "Artist 8", image: nil, containsLyrics: true, containsVoice: true),
    ]
    var reservedSongs: [ReservedSong] = []
    
    func getSongList(limit: Int?, offset: Int?, filter: String?) async throws -> [Song] {
        return someSongs
    }
    
    func deleteSong(_ song: Song) async throws {
        throw notImplemented()
    }
    
    func reserveSong(_ song: Song) async throws {
        let id = UUID().uuidString
        reservedSongs.append(
            DemoReservedSong(identifier: id, currentlyPlaying: reservedSongs.isEmpty, song: song)
        )
    }
    
    func getReservedSongs() async throws -> [ReservedSong] {
        if reservedSongs.isEmpty {
            var randomNumberBetween3and7 = Int.random(in: 3..<8)
            for _ in 0..<randomNumberBetween3and7 {
                if let song = someSongs.randomElement() {
                    try await reserveSong(song)
                }
            }
        }
        return reservedSongs
    }
    
    func playNext() async throws {
        throw notImplemented()
    }
    
    func cancelReservation(_ song: ReservedSong) async throws {
        throw notImplemented()
    }
    
    func stopCurrentlyPlaying() async throws {
        throw notImplemented()
    }
    
    func identifySong(from url: String) async throws -> Song {
        throw notImplemented()
    }
    
    func downloadSong(_ song: DownloadSongParameter) async throws -> Song {
        throw notImplemented()
    }
}

struct DemoSong: Song {
    var identifier: String
    var title: String
    var artist: String?
    var image: String?
    var containsLyrics: Bool
    var containsVoice: Bool
    var language: String?
    var source = "brain"
}

struct DemoReservedSong: ReservedSong {
    var identifier: String
    var currentlyPlaying: Bool
    var song: Song
}
