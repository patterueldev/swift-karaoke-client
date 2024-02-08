//
//  SongListViewModel.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import SwiftUI
import krk_common

class SongListViewModel: ObservableObject {
    private let getSongs: GetSongsUseCase
    private let reserveSongs: ReserveSongUseCase
    private let deleteSong: DeleteSongUseCase
    
    init() {
        let dependencyManager = DependencyManager.shared
        self.getSongs = dependencyManager.getSongsUseCase
        self.reserveSongs = dependencyManager.reserveSongUseCase
        self.deleteSong = dependencyManager.deleteSongUseCase
    }
    
    @Published var showsConnectToServer: Bool = false
    @Published var showsReservedSongList: Bool = false
    @Published var songs: [SongWrapper] = []
    @Published var searchText: String = ""
    
    private var searchTimer: Timer?
    
    func setup() {
        self.loadSongs()
    }
    
    func loadSongs() {
        Task {
            do {
                let songs = try await getSongs.execute(
                    limit: 0,
                    offset: 0,
                    filter: searchText
                ).map { SongWrapper($0) }
                await MainActor.run {
                    self.songs = songs
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func runSearch() {
        searchTimer?.invalidate()
        let isEmpty = searchText.isEmpty
        let interval: TimeInterval = isEmpty ? 0 : 0.25
        searchTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { [weak self] _ in
            self?.searchTimer?.invalidate()
            self?.loadSongs()
        })
    }
    
    func reserveSong(identifier: String) {
        print("Reserving song \(identifier)")
        
        Task {
            do {
                let song = songs.first { $0.id == identifier }
                guard let song = song else { throw NSError(domain: "SongListViewModel", code: 1, userInfo: nil) }
                
                try await reserveSongs.execute(song: song.song)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteSong(identifier: String) {
        print("Deleting song \(identifier)")
        
        Task {
            do {
                let song = songs.first { $0.id == identifier }
                guard let song = song else { throw NSError(domain: "SongListViewModel", code: 1, userInfo: nil) }
                
                try await deleteSong.execute(song: song.song)
                // refresh the list
                loadSongs()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

    struct SongWrapper: Identifiable {
        let id: String
        let song: Song
        
        init(_ song: Song) {
            self.id = song.identifier
            self.song = song
        }
    }
}
