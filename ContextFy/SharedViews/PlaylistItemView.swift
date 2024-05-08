//
//  PlaylistItemView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 07/05/24.
//

import SwiftUI

struct PlaylistItemView: View {
    let name: String
    let imageUrl: String
    
    var body: some View {
        HStack {
            CachedImageView(urlString: imageUrl)
                .frame(width: 60, height: 60)
            Text(name)
            Spacer()
        }
    }
}

#Preview {
    PlaylistItemView(name: "MILIONARIO E JOSÉ RICO | SUCESSOS", imageUrl: "https://mosaic.scdn.co/640/ab67616d0000b27374fcb49f126bf1dbbefe378eab67616d0000b27375fffda7883387b150c5660cab67616d0000b273b9a06700ccb7ea47d24c1657ab67616d0000b273ed96587b9a84f44f2f115a2e")
}
