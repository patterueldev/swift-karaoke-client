//
//  RestKaraokeDataSource.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

class RestKaraokeDataSource: KaraokeRepository {
    let apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func getSongList(limit: Int?, offset: Int?, filter: String?) async throws -> [Song] {
        var urlParams: [String: String] = [:]
        if let limit = limit {
            urlParams["limit"] = String(limit)
        }
        if let offset = offset {
            urlParams["offset"] = String(offset)
        }
        if let filter = filter {
            urlParams["filter"] = filter
        }
        let response: GenericResponse<[RestSong]> = try await apiManager.getRequest(path: .songs, urlParams: urlParams)
        return response.data
    }
    
    func reserveSong(_ song: Song) async throws {
        let response: GenericResponse<String> = try await apiManager.postRequest(path: .reserve, body: ReserveSongParams(id: song.identifier))
        print("Reserve song response \(response)")
    }
    
    func getReservedSongs() async throws -> [ReservedSong] {
        let response: GenericResponse<[RestReservedSong]> = try await apiManager.getRequest(path: .reserved)
        return response.data
    }
    
    func playNext() async throws {
        throw notImplemented()
    }
    
    func cancelReservation(_ song: ReservedSong) async throws {
        let response: GenericResponse<String> = try await apiManager.deleteRequest(
            path: .cancelReservation(id: song.identifier)
        )
        print("Cancel reservation response \(response)")
    }
    
    func stopCurrentlyPlaying() async throws {
        let response: GenericResponse<String> = try await apiManager.deleteRequest(
            path: .stopCurrent
        )
        print("Stop current response \(response)")
    }
}

private struct ReserveSongParams: Codable {
    let id: String
}


private func notImplemented() -> Error {
    NSError(domain: "DemoKaraokeDataSource", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "Not implemented"
    ])
}


struct GenericResponse<T: Codable>: Codable {
    let data: T
    let message: String
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case status
    }
}
