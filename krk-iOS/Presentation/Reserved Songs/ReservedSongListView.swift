//
//  ReservedSongListView.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import SwiftUI

struct ReservedSongListView: View {
    @ObservedObject var viewModel: ReservedSongListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        self.viewModel = ReservedSongListViewModel()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.songs) { (song: ReservedSongListViewModel.ReservedSongWrapper) in
                    HStack {
                        AsyncImage(url: song.reservedSong.song.image?.asURL()) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill) // Added aspect ratio modifier
                                .frame(width: 50, height: 50)
                                .clipped() // Added clipped modifier to ensure the image doesn't exceed the frame
                        } placeholder: {
                            // Placeholder view with music symbol
                            Image(systemName: "music.note")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50)
                        }
                        .background(Color.gray.opacity(0.5))
                        
                        VStack(alignment: .leading) {
                            Text(song.reservedSong.song.title)
                                .font(.headline)
                            
                            if let artist = song.reservedSong.song.artist {
                                Text(artist)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if song.isCurrentlyPlaying {
                                viewModel.stopCurrent()
                            } else {
                                viewModel.cancelSong(song)
                            }
                        }, label: {
                            let icon = song.isCurrentlyPlaying ? "stop.fill" : "trash"
                            
                            Image(systemName: icon)
                                .font(.system(size: 20))
                                .foregroundColor(.blue.opacity(0.75))
                        })
                        if !song.isCurrentlyPlaying {
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .background(Color.indigo)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    ReservedSongListView()
}
