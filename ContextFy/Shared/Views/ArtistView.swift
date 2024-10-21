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
				.cornerRadius(Constants.defaultCornerRadius)
			Text(name)
			Spacer()
		}
	}
}

#Preview {
	ArtistView(name: "Milionário e José Rico", imageUrl: "https://i.scdn.co/image/ab6761610000e5eb26c5c8d56a8979c644f37de7")
}
