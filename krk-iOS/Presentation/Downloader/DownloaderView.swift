//
//  Downloader.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/10/23.
//

import SwiftUI
import krk_common

struct DownloaderView: View {
    @ObservedObject var viewModel: DownloaderViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let dismisser: (() -> Void)?
    
    init(dismisser: (() -> Void)? = nil) {
        self.viewModel = DownloaderViewModel(
            downloaderManager: DependencyManager.shared.downloaderManager,
            downloadSongUseCase: DependencyManager.shared.downloadSongUseCase
        )
        self.dismisser = dismisser
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text("Title: ")
                            .fontWeight(.bold)
                        TextField("Enter Title", text: $viewModel.title)
                            .font(.system(size: 18))
                            .padding(.vertical, 8)
                            .border(Color.black, width: 1)
                            .padding(4)
                    }
                    HStack {
                        Text("Artist: ")
                            .fontWeight(.bold)
                        TextField("Enter Artist", text: $viewModel.artist)
                            .font(.system(size: 18))
                            .padding(.vertical, 8)
                            .border(Color.black, width: 1)
                    }
                    HStack {
                        Toggle("Contains Lyrics", isOn: $viewModel.containsLyrics)
                            .fontWeight(.bold)
                    }
                    HStack {
                        Toggle("Contains Voice", isOn: $viewModel.containsVoice)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Language: ")
                            .fontWeight(.bold)
                        TextField("Enter Language", text: $viewModel.language)
                            .font(.system(size: 18))
                            .padding(.vertical, 8)
                            .border(Color.black, width: 1)
                            .padding(4)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Image: ").fontWeight(.bold)
                            Spacer()
                        }
                        AsyncImage(url: viewModel.imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill) // Added aspect ratio modifier
                                .frame(maxHeight: 200)
                                .clipped() // Added clipped modifier to ensure the image doesn't exceed the frame
                        } placeholder: {
                            // Placeholder view with music symbol
                            Image(systemName: "music.note")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50)
                        }
                    }
                    Spacer()
                    Button(action: {
                        viewModel.downloadSong {}
                        if let dismisser = dismisser {
                            dismisser()
                        } else {
                            print("No dismisser")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Download")
                    }
                }.padding(20)
            }
            .navigationTitle("New Song")
        }
    }
}

#Preview {
    DependencyManager.setup(environment: .preview, clientType: .controller)
    return DownloaderView()
}

class DownloaderViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var artist: String = ""
    @Published var imageUrl: URL?
    @Published var containsLyrics: Bool = true
    @Published var containsVoice: Bool = false
    @Published var language: String = ""
    
    let downloaderManager: DownloaderManager
    let downloadSongUseCase: DownloadSongUseCase
    
    init(downloaderManager: DownloaderManager, downloadSongUseCase: DownloadSongUseCase) {
        self.downloaderManager = downloaderManager
        self.downloadSongUseCase = downloadSongUseCase
        loadCachedSong()
    }
    
    func loadCachedSong() {
        do {
            let song = try downloaderManager.getCachedSong()
            self.title = song.title
            self.artist = song.artist ?? ""
            self.imageUrl = song.image?.asURL()
            self.containsLyrics = song.containsLyrics
            self.containsVoice = song.containsVoice
            self.language = song.language ?? ""
        } catch {
            print("Error")
        }
    }
    
    func downloadSong(then: @escaping () -> Void) {
        Task {
            do {
                let song = try downloaderManager.getCachedSong()
                let parameter = DownloadSongParameter(
                    identifier: song.identifier,
                    title: title,
                    artist: artist.nullIfEmpty,
                    image: imageUrl?.absoluteString,
                    containsLyrics: containsLyrics,
                    containsVoice: containsVoice,
                    language: language.nullIfEmpty,
                    source: song.source
                )
                let _ = try await downloadSongUseCase.execute(parameter: parameter)
            } catch {
                print("error: \(error)")
            }
        }
    }
}
