//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/8/23.
//

import Foundation

public enum Event: String {
    case ReservedSongListUpdated
    case PlayerClientConnected
    case PlayerClientDisconnected
    case PlayerClientPlay
    case PlayerClientPause
    case PlayerClientResume
    case PlayerClientStop
    case PlayerClientFinishedPlaying
    case ControllerClientConnected
    case ControllerClientDisconnected
    case ControllerReserveSong
    case ControllerCancelReservedSong
    case ControllerSongPaused
    case ControllerSongResumed
    case ControllerSongStopped
}
