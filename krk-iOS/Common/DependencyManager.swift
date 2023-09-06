//
//  DependencyManager.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation

class DependencyManager {
    private static var _shared: DependencyManager!
    static func setup(environment: Environment) {
        _shared = DependencyManager(environment: environment)
    }
    
    static var shared: DependencyManager {
        _shared
    }
    
    private init(environment: Environment) {
        self.environment = environment
    }
    
    private let environment: Environment
    
    lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    lazy var netServiceBrowser: NetServiceBrowser = NetServiceBrowser()
    
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
    
    lazy var karaokeRepository: KaraokeRepository = {
        switch environment {
        case .preview:
            return DemoKaraokeDataSource()
        case .app:
            return RestKaraokeDataSource(apiManager: apiManager)
        }
    }()
    
    lazy var getSongsUseCase: GetSongsUseCase = DefaultGetSongsUseCase(repository: karaokeRepository)
    lazy var reserveSongUseCase: ReserveSongUseCase = DefaultReserveSongUseCase(repository: karaokeRepository)
    lazy var getReservedSongsUseCase: GetReservedSongsUseCase = DefaultGetReservedSongsUseCase(repository: karaokeRepository)
    lazy var cancelReservedSongUseCase: CancelReservedSongUseCase = DefaultCancelReservedSongUseCase(repository: karaokeRepository)
    lazy var stopCurrentlyPlayingUseCase: StopCurrentlyPlayingUseCase = DefaultStopCurrentlyPlayingUseCase(repository: karaokeRepository)
    
    // MARK: - Declarations
    enum Environment {
        case preview
        case app
    }
}
