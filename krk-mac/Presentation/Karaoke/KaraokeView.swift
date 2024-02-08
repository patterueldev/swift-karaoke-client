//
//  KaraokeView.swift
//  krk-mac
//
//  Created by John Patrick Teruel on 9/6/23.
//

import SwiftUI
import AVKit
import krk_common

struct KaraokeView: View {
    @ObservedObject var viewModel: KaraokeViewModel
    
    init() {
        self.viewModel = KaraokeViewModel()
    }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: viewModel.player)
                .ignoresSafeArea()
            buildReservedSongView()
        }
    }
    
    func buildReservedSongView() -> some View {
        HStack(alignment:.top) {
            // Reserved songs: $number
            Spacer()
            VStack(alignment: .leading) {
                Text("Reserved Songs: \(viewModel.reservedSongs.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.white)
                Spacer()
                ForEach(viewModel.reservedSongs) { reservedSong in
                    HStack {
                        Text(reservedSong.reservedSong.song.title)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 24, weight: .bold))
                    }
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(Color.black.opacity(0.25))
            .frame(maxWidth: .infinity, maxHeight: .leastNonzeroMagnitude, alignment: .trailing)
        }
        .background(Color.white.opacity(0.5))
        .padding(10)
    }
    
}

#Preview {
    DependencyManager.setup(environment: .preview, clientType: .player)
    return KaraokeView()
        .previewInterfaceOrientation(.landscapeLeft)
}
