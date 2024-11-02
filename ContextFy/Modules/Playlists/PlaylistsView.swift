//
//  PlaylistsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 07/05/24.
//

import SwiftUI

struct PlaylistsView: View {
	@State private var searchText = ""
	@State private var multiSelection = Set<String>()
	
	@EnvironmentObject private var playlistsViewModel: PlaylistsViewModel
	
	private var hasPlaylists: Bool {
		return !playlistsViewModel.isLoading && !playlistsViewModel.playlists.isEmpty
	}
	
	private var filteredPlaylists: [Playlist] {
		if searchText.isEmpty {
			return playlistsViewModel.playlists
		} else {
			return playlistsViewModel.playlists.filter({ $0.name.localizedCaseInsensitiveContains(searchText) })
		}
	}
	
	private var searchIsEmpty: Bool {
		return !searchText.isEmpty && !playlistsViewModel.playlists.isEmpty && filteredPlaylists.isEmpty
	}
	
	var body: some View {
		VStack {
			if playlistsViewModel.isLoading {
				LoaderView()
			} else if !hasPlaylists {
				ContentUnavailableView(
					"Nenhuma playlist adicionada",
					systemImage: SystemIcons.playlists,
					description: Text("Clique em selecionar para adicionar novas playlists a sua lista."))
			} else {
				VStack {
					if searchIsEmpty {
						ContentUnavailableView.search(text: searchText)
					} else {
						List {
							ForEach(filteredPlaylists, id: \.sptfPlaylistId) {
								PlaylistItemView(name: $0.name, imageUrl: $0.images.first?.url ??  "")
							}.onDelete(perform: { indexSet in
								Task {
									await playlistsViewModel.deletePlaylist(at: indexSet)
								}
							})
						}
					}
				}
				.searchable(text: $searchText)
			}
		}
		.onAppear {
			Task {
				await playlistsViewModel.loadPlaylists()
			}
		}
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button("Adicionar", action: playlistsViewModel.startPlaylistSelection)
			}
			
		}
		.navigationTitle("Playlists")
		.navigationBarTitleDisplayMode(.inline)
		.sheet(isPresented: $playlistsViewModel.isSelectingPlaylists) {
			SelectPlaylistsView()
		}
	}
}

#Preview {
	NavigationView {
		PlaylistsView()
	}
}

