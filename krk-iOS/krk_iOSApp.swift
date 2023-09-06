//
//  krk_iOSApp.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import SwiftUI
import krk_common

@main
struct krk_iOSApp: App {
    init() {
        DependencyManager.setup(environment: .app)
    }
    
    var body: some Scene {
        WindowGroup {
            SongListView()
        }
    }
}
