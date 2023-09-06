//
//  ReservedSong.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

protocol ReservedSong {
    var identifier: String { get }
    var currentlyPlaying: Bool { get }
    var song: Song { get }
}
