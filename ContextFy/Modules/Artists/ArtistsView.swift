//
//  UserPreferencesView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 15/04/24.
//

import SwiftUI

struct ArtistsView: View {
	@State private var searchText = ""
	@State private var loading = false
	@State private var artists: [Artist] = []
	@State private var selectArtistIsPresented = false
	@State private var artistsLoaded = false
	@State private var multiSelection = Set<String>()
	
	@EnvironmentObject private var artistRepository: ArtistRepository
	
	private func filteredArtists() -> [Artist] {
		if searchText.isEmpty {
			return artists
		} else {
			return artists.filter({ $0.name.localizedCaseInsensitiveContains(searchText) })
		}
	}
	
	var body: some View {
		VStack {
			if loading {
				ProgressView()
			} else {
				List {
					ForEach(filteredArtists(), id: \.sptfArtistId) {
						ArtistView(name: $0.name, imageUrl: $0.images.first?.url ??  "")
					}.onDelete(perform: deleteArtist)
				}
				.searchable(text: $searchText)
			}
		}
		.onAppear(perform: query)
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button {
					selectArtistIsPresented = true
				} label: {
					Text("Adicionar")
				}
			}
			
		}
		.navigationTitle("Artistas")
		.navigationBarTitleDisplayMode(.inline)
		.sheet(isPresented: $selectArtistIsPresented) {
			SelectArtistsView() { artists.append(contentsOf: $0) }
		}
	}
	
	private func query() {
		if artistsLoaded { return }
		Task {
			loading = true
			do {
				artists = try await artistRepository.all()
				artistsLoaded = true
			} catch {
				print("Canno`t query artists. \(error)")
			}
			loading = false
		}
	}
	
	private func deleteArtist(at indexSet: IndexSet) {
		guard let index = indexSet.first else { return }
		let artistToDelete = artists[index]
		Task {
			do {
				try artistRepository.delete(id: artistToDelete.id!)
				artists.remove(at: index)
			} catch {
				print("Error deleting artist: \(error)")
			}
		}
	}
}

#Preview {
	NavigationView {
		ArtistsView()
	}
}
