//
//  TrackView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 12/04/24.
//

import SwiftUI

struct TrackView: View {
    let name: String
    let artistName: String
    let albumName: String
    let albumImageUrl: String
    
    var body: some View {
        HStack {
            CachedImageView(urlString: albumImageUrl)
                .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Text(name)
                    .bold()
                HStack {
                    Text("\(artistName) - \(albumName)")
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "play.circle")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 32))
                    .padding(.leading, 20)
            }
        }
    }
}

#Preview {
    TrackView(
        name: "The Final Countdown",
        artistName: "Europe",
        albumName: "The Final Countdown",
        albumImageUrl: "https://i.scdn.co/image/ab67616d0000b2732d925cec3072ed1b74e5188f"
    )
}
