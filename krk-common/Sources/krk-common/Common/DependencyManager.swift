//
//  DependencyManager.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation
import SocketIO

public class DependencyManager {
    private static var _shared: DependencyManager!
    public static func setup(environment: Environment, clientType: ClientType) {
        _shared = DependencyManager(environment: environment, clientType: clientType)
    }
    
    public static var shared: DependencyManager {
        _shared
    }
    
    private init(environment: Environment, clientType: ClientType) {
        self.environment = environment
        self.clientType = clientType
    }
    
    private let environment: Environment
    private let clientType: ClientType
    
    public lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    public lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    public lazy var netServiceBrowser: NetServiceBrowser = NetServiceBrowser()
    
    lazy var apiManager: APIManager = {
        var apiManager = DefaultAPIManager(encoder: encoder, decoder: decoder)
        switch environment {
        case .preview:
            try! apiManager.setBaseURL("http://localhost:3000")
            break;
        default: break;
        }
        return apiManager
    }()
    
    lazy var socketManager: SocketManager = {
        var socketManager = SocketManager(
            socketURL: URL(string: "http://Saturday.local:3000")!,
            config: [.log(true), .compress]
        )
        return socketManager
    }()
    
    lazy var karaokeRepository: KaraokeRepository = {
        switch environment {
        case .preview:
            return DemoKaraokeDataSource()
        case .app:
            return RestKaraokeDataSource(apiManager: apiManager)
        }
    }()
    lazy var socketRepository: SocketRepository = {
        switch environment {
        case .preview:
            return RestSocketDataSource(clientType: clientType, socketManager: socketManager)
        case .app:
            return RestSocketDataSource(clientType: clientType, socketManager: socketManager)
        }
    }()
    
    public lazy var getSongsUseCase: GetSongsUseCase = DefaultGetSongsUseCase(repository: karaokeRepository)
    public lazy var reserveSongUseCase: ReserveSongUseCase = DefaultReserveSongUseCase(repository: karaokeRepository)
    public lazy var getReservedSongsUseCase: GetReservedSongsUseCase = DefaultGetReservedSongsUseCase(repository: karaokeRepository)
    public lazy var cancelReservedSongUseCase: CancelReservedSongUseCase = DefaultCancelReservedSongUseCase(repository: karaokeRepository)
    public lazy var stopCurrentlyPlayingUseCase: StopCurrentlyPlayingUseCase = DefaultStopCurrentlyPlayingUseCase(repository: karaokeRepository)
    public lazy var observeReservedSongsUseCase: ObserveReservedSongsUseCase = DefaultObserveReservedSongsUseCase(socketRepository: socketRepository)
    public lazy var observeServerCommandUseCase: ObserveServerCommandUseCase = DefaultObserveServerCommandUseCase(socketManager: socketManager, decoder: decoder)
    public lazy var triggerServerEventUseCase: TriggerServerEventUseCase = DefaultTriggerServerEventUseCase(socketManager: socketManager)
    
    // MARK: - Declarations
    public enum Environment {
        case preview
        case app
    }
}
