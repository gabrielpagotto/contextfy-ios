//
//  HomeView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

// Temp
private struct Music: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
}

struct HomeView: View {
    
    // Temp
    private var playlist: [Music] {
        var songs: [Music] = []
        for i in 1...50 {
            songs.append(Music(title: "Song \(i)", artist: "Artist \(i)"))
        }
        return songs
    }
    
    var body: some View {
        NavigationView {
            List {
                Section() {
                    Label("Recomendações de música para o contexto atual", systemImage: "beats.headphones")
                        .bold()
                        .font(.title3)
                        .padding(.leading)
                }
                
                ForEach(playlist) { song in
                    Label(
                        title: { HStack { 
                            Text(song.title)
                            Spacer()
                            Text(song.artist)
                                .foregroundStyle(.secondary)
                        } },
                        icon: { Image(systemName: "music.note") }
                    )
                }
            }
            .navigationTitle("ContextFy")
        }
    }
}

#Preview {
    HomeView()
}
