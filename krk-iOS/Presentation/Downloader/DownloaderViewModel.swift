//
//  DownloaderViewModel.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/9/23.
//

import SwiftUI

class DownloaderViewModel: ObservableObject {
    @Published var url: String = ""
    var manager: DownloaderManager
    
    init(manager: DownloaderManager) {
        self.manager = manager
        
        setup()
    }
    
    func setup() {
        self.url = manager.getExtractedUrl()
    }
}


