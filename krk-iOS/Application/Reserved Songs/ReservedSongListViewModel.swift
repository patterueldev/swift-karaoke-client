//
//  ReservedSongListViewModel.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import SwiftUI

class ReservedSongListViewModel: ObservableObject {
    private let getReservedSongs: GetReservedSongsUseCase
    private let cancelReservedSong: CancelReservedSongUseCase
    private let stopCurrentSong: StopCurrentlyPlayingUseCase
    
    init() {
        let dependencyManager = DependencyManager.shared
        self.getReservedSongs = dependencyManager.getReservedSongsUseCase
        self.cancelReservedSong = dependencyManager.cancelReservedSongUseCase
        self.stopCurrentSong = dependencyManager.stopCurrentlyPlayingUseCase
    }
    
    @Published var songs: [ReservedSongWrapper] = []
    
    func loadSongs() {
        Task {
            do {
                let songs = try await getReservedSongs.execute().map({ ReservedSongWrapper($0) })
                await MainActor.run {
                    self.songs = songs
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelSong(_ song: ReservedSongWrapper) {
        Task {
            do {
                try await cancelReservedSong.execute(song: song.reservedSong)
                await MainActor.run {
                    self.loadSongs()
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func stopCurrent() {
        Task {
            do {
                try await stopCurrentSong.execute()
                await MainActor.run {
                    self.loadSongs()
                }
            }
        }
    }
    
    struct ReservedSongWrapper: Identifiable {
        let id: String
        let reservedSong: ReservedSong
        
        init(_ song: ReservedSong) {
            self.id = song.identifier
            self.reservedSong = song
        }
    }
}
