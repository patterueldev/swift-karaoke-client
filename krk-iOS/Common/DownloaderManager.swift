//
//  DownloaderManager.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/9/23.
//

import Foundation
import UIKit

protocol DownloaderManager {
    func getExtractedUrl() -> String
    func extractAndDownload(url: URL) -> Bool
    func extractFromClipboard() -> Bool
}

class DefaultDownloaderManager: DownloaderManager {
    private var currentExtractedUrl: String = ""
    
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
}

