//
//  File.swift
//  
//
//  Created by John Patrick Teruel on 9/8/23.
//

import Foundation
import SocketIO

public protocol ObserveServerCommandUseCase {
    func observe() -> AsyncStream<Command>
}

public class DefaultObserveServerCommandUseCase: ObserveServerCommandUseCase {
    let socketManager: SocketManager
    let socket: SocketIOClient
    let decoder: JSONDecoder
    
    
    init(socketManager: SocketManager, decoder: JSONDecoder) {
        self.decoder = decoder
        self.socketManager = socketManager
        self.socket = socketManager.defaultSocket
        self.socket.connect()
    
    }
    
    public func observe() -> AsyncStream<Command> {
        return AsyncStream { continuation in
            socket.on(Event.PlayerClientPlay.rawValue) { [weak self] data, ack in
                // from typescript server: clientEmitter.emit(Event.PlayerClientPlay, reserved[0]);
                guard let song = data.first as? [String: Any] else {
                    return
                }
                print("received play command")
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
        
        }
    }
}

public enum Command {
    case play(id: String)
    case resume
    case pause
}
