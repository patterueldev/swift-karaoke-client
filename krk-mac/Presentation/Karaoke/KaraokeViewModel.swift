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
    private var observer: NSObjectProtocol?
    
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
                print("got updated queue: \(songs.map{$0.song.title})")
                let result = songs.map({ ReservedSongWrapper($0) })
                await MainActor.run {
                    self.reservedSongs = result
                }
            }
        }
    }
    
    func startServerObserver() {
        Task {
            for await command in self.observeServerCommandUseCase.observe() {
                switch command {
                case .play(let id):
                    print("will play \(id)")
                    self.play(id: id)
                case .resume:
                    player?.play()
                case .pause:
                    print("will pause")
                    player?.pause()
                case .stop:
                    print("will stop")
                    player?.pause()
                    await player?.seek(to: .zero)
                    self.player = nil
                }
            }
        }
    }
    
    func play(id: String) {
        self.invalidateObserver()
        self.destroyPlayer()
        
        let url = "http://Saturday.local:3000/media/\(id)"
        self.player = AVPlayer(url: URL(string: url)!)
        self.player?.play()
        observer = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            print("finished playing")
            self?.destroyPlayer()
            self?.triggerServerEventUseCase.emit(event: .PlayerClientFinishedPlaying, data: [id])
            self?.invalidateObserver()
        }
    }
    
    private func invalidateObserver() {
        guard let observer = self.observer else { return }
        NotificationCenter.default.removeObserver(observer)
        self.observer = nil
    }
    
    private func destroyPlayer() {
        self.player?.pause()
        self.player = nil
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
