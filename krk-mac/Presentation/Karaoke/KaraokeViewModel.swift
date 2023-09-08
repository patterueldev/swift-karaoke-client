//
//  KaraokeViewModel.swift
//  krk-mac
//
//  Created by John Patrick Teruel on 9/6/23.
//

import SwiftUI
import AVKit
import krk_common

class KaraokeViewModel: ObservableObject {
    let observeReservedSongs: ObserveReservedSongsUseCase
    let observeServerCommandUseCase: ObserveServerCommandUseCase
    let triggerServerEventUseCase: TriggerServerEventUseCase
    
    @Published var reservedSongs: [ReservedSongWrapper] = []
    @Published var player: AVPlayer?
    
    private var currentlyPlaying: ReservedSong?
    private var isPlaying = false
    
    // for now, let's just manually load reserved songs
    let getReservedSongsUseCase: GetReservedSongsUseCase
    
    init() {
        let dependencyManager = DependencyManager.shared
        self.getReservedSongsUseCase = dependencyManager.getReservedSongsUseCase
        self.observeReservedSongs = dependencyManager.observeReservedSongsUseCase
        self.observeServerCommandUseCase = dependencyManager.observeServerCommandUseCase
        self.triggerServerEventUseCase = dependencyManager.triggerServerEventUseCase
        startReservedSongsObserver()
        startServerObserver()
    }
    
    func startReservedSongsObserver() {
        Task {
            print("starting observer")
            for await songs in observeReservedSongs.observe() {
                await MainActor.run {
                    self.reservedSongs = songs.map({ ReservedSongWrapper($0) })
                }
            }
        }
    }
    
    func startServerObserver() {
        Task {
            for await command in self.observeServerCommandUseCase.observe() {
                switch command {
                case .play(let id):
                    self.play(id: id)
                case .resume:
                    player?.play()
                case .pause:
                    print("will pause")
                    player?.pause()
                }
            }
        }
    }
    
    func play(id: String) {
        self.player?.pause()
        
        let url = "http://localhost:3000/song?id=\(id)"
        self.player = AVPlayer(url: URL(string: url)!)
        self.player?.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
            print("finished playing")
            self.triggerServerEventUseCase.emit(event: .PlayerClientFinishedPlaying, data: [id])
        }
        
        self.isPlaying = true
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
