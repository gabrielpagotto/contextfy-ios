//
//  EmptyView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 21/10/24.
//

import SwiftUI

struct EmptyView: View {
	let message: LocalizedStringKey
	let systemImage: String
	
	var body: some View {
		VStack {
			Image(systemName: systemImage)
				.font(.system(size: 40))
			Text(message)
				.font(.title3)
				.multilineTextAlignment(.center)
				.padding(.top, 1)
		}
		.foregroundColor(.secondary)
	}
}

#Preview {
	EmptyView(message: "This is empty.", systemImage: "shippingbox")
}
