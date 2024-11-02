//
//  SelectPlaylistsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 02/11/24.
//

import SwiftUI

struct SelectPlaylistsView: View {
	@State private var searchText = ""
	@State private var currentTask: Task<Void, Never>? = nil
	@State private var multiSelection = Set<String>()
	
	@Environment(\.dismiss) private var dismiss
	
	@EnvironmentObject private var playlistsViewModel: PlaylistsViewModel
	
	var body: some View {
		NavigationView {
			VStack {
				if playlistsViewModel.isSearching {
					LoaderView()
				} else {
					List(playlistsViewModel.searchedPlaylists, id: \.sptfPlaylistId, selection: $multiSelection) {
						PlaylistItemView(name: $0.name, imageUrl: $0.images.first?.url ?? "")
					}
				}
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
						Task { await playlistsViewModel.createPlaylist(ids: multiSelection) }
					} label: {
						if playlistsViewModel.isCreating {
							ProgressView()
								.padding(.zero)
						} else {
							Text("Adicionar \(multiSelection.count)")
								.bold()
						}
					}
					.disabled(multiSelection.count == 0)
				}
			}
			.navigationTitle("Selecionar playlists")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear { Task { await playlistsViewModel.searchPlaylists(query: "") } }
			.onChange(of: searchText, { Task { debounceQuery() } })
			.searchable(text: $searchText)
			.environment(\.editMode, .constant(EditMode.active))
			.interactiveDismissDisabled(true)
		}
	}
	
	private func debounceQuery() {
		currentTask?.cancel()
		currentTask = Task {
			try? await Task.sleep(nanoseconds: 500_000_000)
			if !Task.isCancelled {
				await playlistsViewModel.searchPlaylists(query: searchText)
			}
		}
	}
}

#Preview {
    SelectPlaylistsView()
}
