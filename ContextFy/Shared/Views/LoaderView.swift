//
//  LoaderView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 21/10/24.
//

import SwiftUI

struct LoaderView: View {
	var body: some View {
		VStack {
			ProgressView()
			Text("Carregando...")
				.padding(.top, 2)
				.foregroundStyle(.secondary)
		}
	}
}

#Preview {
	LoaderView()
}
