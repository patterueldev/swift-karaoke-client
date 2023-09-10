//
//  ReservedSong.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

public protocol ReservedSong {
    var identifier: String { get }
    var song: Song { get }
}
