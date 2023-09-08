//
//  ReservedSongListViewModel.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import SwiftUI
import krk_common

class ReservedSongListViewModel: ObservableObject {
    private let observeReservedSongs: ObserveReservedSongsUseCase
    private let triggerServerEventUseCase: TriggerServerEventUseCase
    private let cancelReservedSong: CancelReservedSongUseCase
    private let stopCurrentSong: StopCurrentlyPlayingUseCase
    
    init() {
        let dependencyManager = DependencyManager.shared
        self.observeReservedSongs = dependencyManager.observeReservedSongsUseCase
        self.cancelReservedSong = dependencyManager.cancelReservedSongUseCase
        self.stopCurrentSong = dependencyManager.stopCurrentlyPlayingUseCase
        self.triggerServerEventUseCase = dependencyManager.triggerServerEventUseCase
        
        self.startObserver()
    }
    
    @Published var songs: [ReservedSongWrapper] = []
    @Published var showsSongBook: Bool = false
    
    func startObserver() {
        Task {
            for await songs in observeReservedSongs.observe() {
                await MainActor.run {
                    self.songs.removeAll()
                    for i in 0..<songs.count {
                        self.songs.append(ReservedSongWrapper(songs[i], isCurrentlyPlaying: i == 0))
                    }
                }
            }
        }
    }
    
    func cancelSong(_ song: ReservedSongWrapper) {
        Task {
            do {
                try await cancelReservedSong.execute(song: song.reservedSong)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func stopCurrent() {
        Task {
            do {
                self.triggerServerEventUseCase.emit(event: .ControllerSongStopped, data: [])
            }
        }
    }
    
    struct ReservedSongWrapper: Identifiable {
        let id: String
        let reservedSong: ReservedSong
        let isCurrentlyPlaying: Bool
        
        init(_ song: ReservedSong, isCurrentlyPlaying: Bool) {
            self.id = song.identifier
            self.reservedSong = song
            self.isCurrentlyPlaying = isCurrentlyPlaying
        }
    }
}
