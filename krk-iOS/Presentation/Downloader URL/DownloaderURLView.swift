//
//  DownloaderView.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/9/23.
//

import SwiftUI
import krk_common

struct DownloaderURLView: View {
    @ObservedObject var viewModel: DownloaderURLViewModel
    
    init(manager: DownloaderManager) {
        self.viewModel = DownloaderURLViewModel(manager: manager)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Download from URL")
                        .font(.headline)
                    TextField("Enter URL", text: $viewModel.url)
                        .padding()
                    
                    Button("Identify Song") {
                        viewModel.identify()
                    }
                    .padding()
                }
                
                if viewModel.isLoading {
                    Color.black.opacity(0.4) // Dim the background
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5, anchor: .center) // Adjust the scale as needed
                            .padding()
                        Text("Loading...")
                            .foregroundColor(.white)
                    }
                }
            }
            .navigationTitle("New Song")
            .navigationDestination(isPresented: $viewModel.navigatesToSongDownloader) {
                DownloaderView()
            }
        }
    }
}

#Preview {
    DependencyManager.setup(environment: .preview, clientType: .controller)
    return DownloaderURLView(manager: DependencyManager.shared.downloaderManager)
}
