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
    let decoder: JSONDecoder
    
    init(clientType: ClientType, socketManager: SocketManager, decoder: JSONDecoder) {
        self.clientType = clientType
        self.socketManager = socketManager
        self.socket = socketManager.defaultSocket
        self.decoder = decoder
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
    
    
    func observeServerCommands() -> AsyncStream<Command> {
        self.prepareOnce()
        return AsyncStream { continuation in
            socket.on(Event.PlayerClientPlay.rawValue) { [weak self] data, ack in
                print("received play command")
                guard let song = data.first as? [String: Any] else {
                    return
                }
                print("Song: \(song)")
                do {
                    let data = try JSONSerialization.data(withJSONObject: song, options: [])
                    guard let raw = try self?.decoder.decode(RestReservedSong.self, from: data) else {
                        throw NSError(domain: "Decode error", code: 0, userInfo: nil)
                    }
                    print("Playing song: \(raw.song.identifier)")
                    continuation.yield(.play(id: raw.song.identifier))
                } catch {
                    print("Error decoding song: \(error)")
                }
            }
            
            socket.on(Event.PlayerClientPause.rawValue) { data, ack in
                continuation.yield(.pause)
            }
            
            socket.on(Event.PlayerClientResume.rawValue) { data, ack in
                guard let id = data.first as? String else { return }
                continuation.yield(.resume)
            }
        
            socket.on(Event.PlayerClientStop.rawValue) { data, ack in
                continuation.yield(.stop)
            }
        }
    }
}
