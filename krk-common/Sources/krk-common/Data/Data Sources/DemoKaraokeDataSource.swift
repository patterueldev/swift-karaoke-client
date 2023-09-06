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
        DemoSong(identifier: "1", title: "Song 1", artist: "Artist 1", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "2", title: "Song 2", artist: "Artist 2", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "3", title: "Song 3", artist: "Artist 3", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "4", title: "Never Gonna Give You Up", artist: "Rick Astley", image: "https://variety.com/wp-content/uploads/2021/07/Rick-Astley-Never-Gonna-Give-You-Up.png?w=1024", containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "5", title: "Song 5", artist: "Artist 5", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "6", title: "Song 6", artist: "Artist 6", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "7", title: "Song 7", artist: "Artist 7", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "8", title: "Song 8", artist: "Artist 8", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "9", title: "Song 9", artist: "Artist 9", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "10", title: "Song 10", artist: "Artist 10", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "11", title: "Song 11", artist: "Artist 11", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "12", title: "Song 12", artist: "Artist 12", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "13", title: "Song 13", artist: "Artist 13", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "14", title: "Song 14", artist: "Artist 14", image: nil, containsLyrics: true, containsVoice: true),
        DemoSong(identifier: "15", title: "Song 15", artist: "Artist 15", image: nil, containsLyrics: true, containsVoice: true),
    ]
    var reservedSongs: [ReservedSong] = []
    
    func getSongList(limit: Int?, offset: Int?, filter: String?) async throws -> [Song] {
        return someSongs
    }
    
    func reserveSong(_ song: Song) async throws {
        let id = UUID().uuidString
        reservedSongs.append(
            DemoReservedSong(identifier: id, currentlyPlaying: reservedSongs.isEmpty, song: song)
        )
    }
    
    func getReservedSongs() async throws -> [ReservedSong] {
        if reservedSongs.isEmpty {
            if let song = someSongs.randomElement() {
                try await reserveSong(song)
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
}

struct DemoSong: Song {
    var identifier: String
    var title: String
    var artist: String?
    var image: String?
    var containsLyrics: Bool
    var containsVoice: Bool
}

struct DemoReservedSong: ReservedSong {
    var identifier: String
    var currentlyPlaying: Bool
    var song: Song
}
