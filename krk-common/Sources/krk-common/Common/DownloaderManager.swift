//
//  DownloaderManager.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/9/23.
//

import UIKit

public protocol DownloaderManager {
    func getExtractedUrl() -> String
    func extractAndDownload(url: URL) -> Bool
    func extractFromClipboard() -> Bool
    func setCachedSong(_ song: Song)
    func getCachedSong() throws -> Song
}

class DefaultDownloaderManager: DownloaderManager {
    private var currentExtractedUrl: String = ""
    private var cachedSong: Song?
    
    func getExtractedUrl() -> String {
        return currentExtractedUrl
    }
    
    func extractAndDownload(url: URL) -> Bool {
        // extract youtube url from krkios://download/?url=<youtube url>
        // sample: krkios://download/?url=https://youtube.com/watch?v=xOlgH5dvB68&si=OVHEFn2V9rcbLDms
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let youtubeUrl = urlComponents?.queryItems?.filter({ $0.name == "url" }).first?.value
        guard let extractedUrl = youtubeUrl else {
            return false
        }
        self.currentExtractedUrl = extractedUrl
        return true
    }
    
    func extractFromClipboard() -> Bool {
        guard let clipboardString = UIPasteboard.general.string,
              let url = URL(string: clipboardString) else {
            return false
        }
        self.currentExtractedUrl = url.absoluteString
        return true
    }
    
    func setCachedSong(_ song: Song) {
        self.cachedSong = song
    }
    
    func getCachedSong() throws -> Song {
        guard let song = cachedSong else {
            throw NSError(domain: "No cached song", code: 0, userInfo: nil)
        }
        return song
    }

}

class DemoDownloaderManager: DownloaderManager {
    func getExtractedUrl() -> String {
        return "https://youtube.com/watch?v=xOlgH5dvB68"
    }
    
    func extractAndDownload(url: URL) -> Bool {
        return true
    }
    
    func extractFromClipboard() -> Bool {
        return true
    }
    
    func setCachedSong(_ song: Song) {
        
    }
    
    func getCachedSong() throws -> Song {
        return DemoSong(identifier: "64f4752dbc2f36acb2c0ae9a", title: "Never Gonna Give You Up", artist: "Rick Astley", image: "https://variety.com/wp-content/uploads/2021/07/Rick-Astley-Never-Gonna-Give-You-Up.png?w=1024", containsLyrics: true, containsVoice: false)
    }
}
