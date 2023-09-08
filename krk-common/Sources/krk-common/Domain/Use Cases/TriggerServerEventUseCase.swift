//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/8/23.
//

import Foundation
import SocketIO

public protocol TriggerServerEventUseCase {
    func emit(event: Event, data: [Any])
}

class DefaultTriggerServerEventUseCase: TriggerServerEventUseCase {
    let socketManager: SocketManager
    let socket: SocketIOClient
    
    init(socketManager: SocketManager) {
        self.socketManager = socketManager
        self.socket = socketManager.defaultSocket
        self.socket.connect()
    }
    
    func emit(event: Event, data: [Any]) {
        self.socket.emit(event.rawValue, data)
    }
}

