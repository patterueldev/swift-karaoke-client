//
//  SongListView.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import SwiftUI
import krk_common

struct SongListView: View {
    @ObservedObject var viewModel: SongListViewModel
    
    init() {
        self.viewModel = SongListViewModel()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.songs) { song in
                    HStack {
                        AsyncImage(url: song.song.image?.asURL()) { image in
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
                            Text(song.song.title)
                                .font(.headline)
                            
                            if let artist = song.song.artist {
                                Text(artist)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.reserveSong(identifier: song.id)
                        }, label: {
                            Image(systemName: "mic")
                                .font(.system(size: 20))
                                .foregroundColor(.blue.opacity(0.75))
                        
                        })
                    }
                }
                .scrollContentBackground(.hidden)
                .refreshable(action: {
                    viewModel.loadSongs()
                })
                VStack{
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.showsReservedSongList.toggle()
                        }, label: {
                            Image(systemName: "book.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        })
                        .padding()
                        .background(.blue.opacity(0.75))
                        .clipShape(Circle()) // Make the button circular
                    }.padding(.horizontal, 16)
                }
            }
        }
        .background(Color.indigo) // Set the background color of the bottom bar
        .searchable(text: $viewModel.searchText, prompt: "Search for Title, Artist")
        .onSubmit(of: .search) { viewModel.loadSongs() }
        .onAppear() {
            viewModel.setup()
        }.sheet(isPresented: $viewModel.showsReservedSongList, content: {
            ReservedSongListView()
        })
    }
    
    func didFinishedSettingUp() {
        viewModel.setup()
    }
}

#Preview {
    DependencyManager.setup(environment: .preview)
    return SongListView()
}
