//
//  KaraokeDataSource.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation

protocol KaraokeRepository {
    func getSongList(limit: Int?, offset: Int?, filter: String?) async throws -> [Song]
    func reserveSong(_ song: Song) async throws
    func getReservedSongs() async throws -> [ReservedSong]
    func playNext() async throws
    func cancelReservation(_ song: ReservedSong) async throws
    func stopCurrentlyPlaying() async throws
}
