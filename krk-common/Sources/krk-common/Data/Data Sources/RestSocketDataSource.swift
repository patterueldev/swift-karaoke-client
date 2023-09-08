//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/6/23.
//

import Foundation
import SocketIO

class RestSocketDataSource: SocketRepository {
    let clientType: ClientType
    let socketManager: SocketManager
    let socket: SocketIOClient
    
    init(clientType: ClientType, socketManager: SocketManager) {
        self.clientType = clientType
        self.socketManager = socketManager
        self.socket = socketManager.defaultSocket
        self.socket.connect()
    }
    
    var prepared = false
    func prepareOnce() {
        if prepared { return }
        print("preparing socket")
        self.prepared = true
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
            let event: Event
            switch self.clientType {
            case .controller:
                event = .ControllerClientConnected
            case .player:
                event = .PlayerClientConnected
            }
            self.socket.emit(event.rawValue)
        }
        
        socket.on(clientEvent: .error, callback: { data, ack in
            print("Socket error occurred:")
            data.forEach { print($0) }
        })
    
        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected")
        }
    }
    
    func observeReservedSongs() -> AsyncStream<[ReservedSong]> {
        self.prepareOnce()
        return AsyncStream { continuation in
            socket.on("ReservedSongListUpdated") { data, ack in
                guard let rawArray = data.first as? [[String: Any]] else { return }
                let reservedSongs: [RestReservedSong] = rawArray.compactMap { (raw) -> RestReservedSong? in
                    guard let data = try? JSONSerialization.data(withJSONObject: raw, options: []) else { return nil }
                    return try? JSONDecoder().decode(RestReservedSong.self, from: data)
                }
                continuation.yield(reservedSongs)
            }
        }
    }
}
