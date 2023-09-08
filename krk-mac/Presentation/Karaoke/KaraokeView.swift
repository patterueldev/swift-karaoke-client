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
            Spacer()
            VStack(alignment: .leading) {
                Text("Reserved Songs")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.bottom, 10)
                ForEach(viewModel.reservedSongs) { reservedSong in
                    Text(reservedSong.reservedSong.song.title)
                        .foregroundStyle(Color.white)
                        .font(.system(size: 16, weight: .bold))
                }
                Spacer()
            }
            .padding(10)
        }
    }
    
}

#Preview {
    DependencyManager.setup(environment: .preview, clientType: .player)
    return KaraokeView()
        .previewInterfaceOrientation(.landscapeLeft)
}
