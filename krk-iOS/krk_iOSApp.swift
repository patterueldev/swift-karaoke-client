//
//  krk_iOSApp.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import SwiftUI
import krk_common

class AppHelper {
    var url: String = ""
}
@main
struct krk_iOSApp: App {
    init() {
        DependencyManager.setup(environment: .app, clientType: .controller)
    }
    
    @State var isDownloaderPresented: Bool = false
    
    let appHelper: AppHelper = AppHelper()
    
    // Implement URL handling
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ReservedSongListView(downloadToggler: {
                self.isDownloaderPresented = true
            })
                .sheet(isPresented: $isDownloaderPresented, content: {
                    DownloaderURLView(manager: DependencyManager.shared.downloaderManager, dismisser: {
                        self.isDownloaderPresented = false
                    })
                })
                .onOpenURL(perform: { url in
                    print("URL found: \(url)")
                    if url.scheme == "krkios" {
                        self.isDownloaderPresented = DependencyManager.shared.downloaderManager.extractAndDownload(url: url)
                    }
                })
                .onAppear {
                    self.isDownloaderPresented = DependencyManager.shared.downloaderManager.extractFromClipboard()
                }
        }
    }
}
