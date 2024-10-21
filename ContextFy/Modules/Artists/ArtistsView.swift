//
//  UserPreferencesView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 15/04/24.
//

import SwiftUI

struct ArtistsView: View {
	@State private var searchText = ""
	@State private var multiSelection = Set<String>()
	
	@EnvironmentObject private var artistsViewModel: ArtistsViewModel
	
	private var hasArtists: Bool {
		return !artistsViewModel.isLoading && !artistsViewModel.artists.isEmpty
	}
	
	private var filteredArtists: [Artist] {
		if searchText.isEmpty {
			return artistsViewModel.artists
		} else {
			return artistsViewModel.artists.filter({ $0.name.localizedCaseInsensitiveContains(searchText) })
		}
	}
	
	private var searchIsEmpty: Bool {
		return !searchText.isEmpty && !artistsViewModel.artists.isEmpty && filteredArtists.isEmpty
	}
	
	var body: some View {
		VStack {
			if artistsViewModel.isLoading {
				LoaderView()
			} else if !hasArtists {
				ContentUnavailableView(
					"Nenhum artista adicionado",
					systemImage: SystemIcons.artists,
					description: Text("Clique em selecionar para adicionar novos artistas a sua lista."))
			} else {
				VStack {
					if searchIsEmpty {
						ContentUnavailableView.search(text: searchText)
					} else {
						List {
							ForEach(filteredArtists, id: \.sptfArtistId) {
								ArtistView(name: $0.name, imageUrl: $0.images.first?.url ??  "")
							}.onDelete(perform: { indexSet in
								Task {
									await artistsViewModel.deleteArtist(at: indexSet)
								}
							})
						}
					}
				}
				.searchable(text: $searchText)
			}
		}
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button("Adicionar", action: artistsViewModel.startArtistSelection)
			}
			
		}
		.navigationTitle("Artistas")
		.navigationBarTitleDisplayMode(.inline)
		.sheet(isPresented: $artistsViewModel.isSelectingArtists) {
			SelectArtistsView()
		}
	}
}

#Preview {
	NavigationView {
		ArtistsView()
			.environmentObject(ArtistsViewModel(artistRepository: ArtistRepositoryPreview()))
	}
}
