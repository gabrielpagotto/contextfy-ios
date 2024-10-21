//
//  PlaylistsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 07/05/24.
//

import SwiftUI

struct PlaylistsView: View {
	@State private var search = ""
	@State private var selectPlaylistIsPresented = false
	
	var body: some View {
		List {
			ForEach(0..<50) { i in
				PlaylistItemView(name: "MILIONARIO E JOSÉ RICO | SUCESSOS", imageUrl: "https://mosaic.scdn.co/640/ab67616d0000b27374fcb49f126bf1dbbefe378eab67616d0000b27375fffda7883387b150c5660cab67616d0000b273b9a06700ccb7ea47d24c1657ab67616d0000b273ed96587b9a84f44f2f115a2e")
			}
			.onDelete(perform: { indexSet in
			})
		}
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button {
					selectPlaylistIsPresented = true
				} label: {
					Text("Adicionar")
				}
			}
			
		}
		.sheet(isPresented: $selectPlaylistIsPresented) {
			SelectPlaylistView()
		}
		.navigationTitle("Playlists")
		.navigationBarTitleDisplayMode(.inline)
		.searchable(text: $search)
	}
}

#Preview {
	NavigationView {
		PlaylistsView()
	}
}

struct SelectPlaylistView: View {
	@State private var search = ""
	
	@Environment(\.dismiss) private var dismiss
	@State private var multiSelection = Set<Int>()
	
	var body: some View {
		NavigationView {
			List(0..<50, id: \.self, selection: $multiSelection) { i in
				PlaylistItemView(name: "MILIONARIO E JOSÉ RICO | SUCESSOS", imageUrl: "https://mosaic.scdn.co/640/ab67616d0000b27374fcb49f126bf1dbbefe378eab67616d0000b27375fffda7883387b150c5660cab67616d0000b273b9a06700ccb7ea47d24c1657ab67616d0000b273ed96587b9a84f44f2f115a2e")
			}
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button {
						dismiss()
					} label: {
						Text("Fechar")
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button {
						dismiss()
					} label: {
						Text("Adicionar \(multiSelection.count)")
							.disabled(multiSelection.count == 0)
					}
				}
			}
			.navigationTitle("Selecionar playlist")
			.navigationBarTitleDisplayMode(.inline)
			.searchable(text: $search)
			.environment(\.editMode, .constant(EditMode.active))
			.interactiveDismissDisabled(true)
		}
	}
}
