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
    let playing: Bool
    let onPlayPressed: () -> Void
    
    var body: some View {
        HStack {
            CachedImageView(urlString: albumImageUrl)
                .frame(width: 60, height: 60)
                .cornerRadius(Constants.defaultCornerRadius)
            VStack(alignment: .leading) {
                Text(name)
                    .bold()
                HStack {
                    Text("\(artistName) - \(albumName)")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            }
            Spacer()
            Button {
                onPlayPressed()
            } label: {
                Image(systemName: playing ? "pause.circle" : "play.circle")
                    .foregroundColor(playing ? .primary : .accentColor)
                    .font(.system(size: 32))
                    .padding(.leading, 20)
            }
        }
    }
}

#Preview {
    TrackView(
        name: "Decida",
        artistName: "Milionário e José Rico",
        albumName: "Atravessando Gerações",
        albumImageUrl: "https://i.scdn.co/image/ab67616d0000b273ed96587b9a84f44f2f115a2e",
        playing: false,
        onPlayPressed: { }
    )
}
