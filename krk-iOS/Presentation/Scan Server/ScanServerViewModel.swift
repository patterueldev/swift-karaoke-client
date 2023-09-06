//
//  ScanServerViewModel.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import SwiftUI

class ScanServerViewModel: ObservableObject {
    private let decoder: JSONDecoder
    private let apiManager: APIManager
    
    init() {
        let dependencyManager = DependencyManager.shared
        self.decoder = dependencyManager.decoder
        self.apiManager = dependencyManager.apiManager
    }
    
    func scanServer(qrResult: Result<String, Error>, completion: @escaping () -> Void) {
        Task {
            do {
                let qrCode = try qrResult.get()
                guard let data = qrCode.data(using: .utf8) else {
                    throw NSError(domain: "Invalid QR Code", code: 0, userInfo: nil)
                }
                let serverQRObject = try decoder.decode(ServerQRObject<String>.self, from: data)
                try apiManager.setBaseURL(serverQRObject.data)
                let isSetup = try await apiManager.checkIfServerIsSetup()
                if !isSetup {
                    throw NSError(domain: "Server is not setup properly or base url is not valid", code: 0, userInfo: nil)
                }
                await MainActor.run {
                    completion()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ServerQRObject<T: Codable>: Codable {
    let type: String
    let data: T
    let title: String
    let description: String
}

/*
 {"type":"baseURL","data":"http://192.168.254.104:3000","title":"Base URL for the Karaoke Server","description":"Scan this QR code to connect to the server"}
 */
