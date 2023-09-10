//
//  Song.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation

public protocol Song {
    var identifier: String { get }
    var title: String { get }
    var artist: String? { get }
    var image: String? { get }
    var containsLyrics: Bool { get }
    var containsVoice: Bool { get }
    var language: String? { get }
    var source: String { get }
}
