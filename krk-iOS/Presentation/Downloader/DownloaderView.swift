//
//  DownloaderView.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/9/23.
//

import SwiftUI

struct DownloaderView: View {
    @ObservedObject var viewModel: DownloaderViewModel
    
    init(manager: DownloaderManager) {
        self.viewModel = DownloaderViewModel(manager: manager)
    }
    
    var body: some View {
        VStack {
            Text("Downloader")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            TextField("Enter URL", text: $viewModel.url)
                .padding()
            
            Button("Download") {
                print("Download button tapped!")
            }
            .padding()
        }
    }
}

#Preview {
    DownloaderView(manager: DefaultDownloaderManager())
}
