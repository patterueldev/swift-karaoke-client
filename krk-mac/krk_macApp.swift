//
//  krk_macApp.swift
//  krk-mac
//
//  Created by John Patrick Teruel on 9/6/23.
//

import SwiftUI
import krk_common

@main
struct krk_macApp: App {
    init() {
        DependencyManager.setup(environment: .app, clientType: .player)
    }
    
    var body: some Scene {
        WindowGroup {
            KaraokeView()
        }
    }
}
