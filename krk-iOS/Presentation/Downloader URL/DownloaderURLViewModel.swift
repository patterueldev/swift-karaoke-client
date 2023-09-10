//
//  DownloaderViewModel.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/9/23.
//

import SwiftUI
import krk_common

class DownloaderURLViewModel: ObservableObject {
    @Published var url: String = ""
    @Published var isLoading: Bool = false
    @Published var navigatesToSongDownloader: Bool = false
    
    let manager: DownloaderManager
    let identifySongFromURL: IdentifySongFromURLUseCase
    
    init(manager: DownloaderManager) {
        self.manager = manager
        self.identifySongFromURL = DependencyManager.shared.identifySongFromURLUseCase
        
        setup()
    }
    
    func setup() {
        self.url = manager.getExtractedUrl()
    }
    
    func identify() {
        Task {
            self.isLoading = true
            do {
                let song = try await identifySongFromURL.execute(url: url)
                manager.setCachedSong(song)
                await MainActor.run {
                    self.navigatesToSongDownloader = true
                }
            } catch {
                print(error)
            }
            self.isLoading = false
        }
    }
}


