//
//  ArtistView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 15/04/24.
//

import SwiftUI

struct ArtistView: View {
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
    ArtistView(name: "Europe", imageUrl: "https://i.scdn.co/image/ab67616d0000b2732d925cec3072ed1b74e5188f")
}
