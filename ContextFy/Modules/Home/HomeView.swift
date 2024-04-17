//
//  HomeView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                Section() {
                    Label("Recomendações para \"Casa\"", systemImage: "beats.headphones")
                        .bold()
                        .padding(.leading)
                }
                
                // TODO: Change this for a real data
                ForEach(0..<50) { i in
                    TrackView(
                        name: "Final Countdown",
                        artistName: "Europe",
                        albumName: "The Final Countdown",
                        albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2732d925cec3072ed1b74e5188f")
                }
            }
            .navigationTitle("ContextFy")
        }
    }
}

#Preview {
    HomeView()
}
