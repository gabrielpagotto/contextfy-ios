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
			Text("CARREGANDO...")
				.padding()
				.foregroundStyle(.secondary)
		}
	}
}

#Preview {
	LoaderView()
}
