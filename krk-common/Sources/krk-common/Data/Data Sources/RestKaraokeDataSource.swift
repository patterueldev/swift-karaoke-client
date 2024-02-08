//
//  RestKaraokeDataSource.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

struct RestKaraokeDataSource: KaraokeRepository {
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
        let response: GenericResponse<String> = try await apiManager.postRequest(path: .reserve(id: song.identifier))
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
    
    func deleteSong(_ song: Song) async throws {
        do {
            let response: GenericResponse<String> = try await apiManager.deleteRequest(
                path: .deleteSong(id: song.identifier)
            )
            print("Delete song response \(response)")
        } catch {
            print("Error deleting song: \(error)")
        }
    }
    
    func stopCurrentlyPlaying() async throws {
        let response: GenericResponse<String> = try await apiManager.deleteRequest(
            path: .stopCurrent
        )
        print("Stop current response \(response)")
    }
    
    func identifySong(from url: String) async throws -> Song {
        let response: GenericResponse<RestSong> = try await apiManager.postRequest(
            path: .identifySong,
            body: ["url": url]
        )
        return response.data
    }
    
    func downloadSong(_ song: DownloadSongParameter) async throws -> Song {
        let response: GenericResponse<RestSong> = try await apiManager.postRequest(path: .downloadSong, body: song)
        return response.data
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
