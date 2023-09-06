//
//  SongListViewModel.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import SwiftUI

class SongListViewModel: ObservableObject {
    private let apiManager: APIManager
    private let getSongs: GetSongsUseCase
    private let reserveSongs: ReserveSongUseCase
    
    init() {
        let dependencyManager = DependencyManager.shared
        self.apiManager = dependencyManager.apiManager
        self.getSongs = dependencyManager.getSongsUseCase
        self.reserveSongs = dependencyManager.reserveSongUseCase
    }
    
    @Published var showsConnectToServer: Bool = false
    @Published var showsReservedSongList: Bool = false
    @Published var songs: [SongWrapper] = []
    @Published var searchText: String = ""
    
    private var searchTimer: Timer?
    
    func setup() {
        Task {
            do {
                // check if API manager is setup properly
                let isSetup = try await apiManager.checkIfServerIsSetup()
                await MainActor.run {
                    self.showsConnectToServer = !isSetup
                    if isSetup { self.loadSongs() }
                }
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    self.showsConnectToServer = true
                }
            }
        }
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
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            self.loadSongs()
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
    

    struct SongWrapper: Identifiable {
        let id: String
        let song: Song
        
        init(_ song: Song) {
            self.id = song.identifier
            self.song = song
        }
    }
}
