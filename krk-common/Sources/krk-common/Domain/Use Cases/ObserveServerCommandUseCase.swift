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
    let socketRepository: SocketRepository
    init(socketRepository: SocketRepository) {
        self.socketRepository = socketRepository
    }
    public func observe() -> AsyncStream<Command> {
        socketRepository.observeServerCommands()
    }
}

public enum Command {
    case play(id: String)
    case resume
    case pause
    case stop
}
