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
			SelectArtistView() { artists.append(contentsOf: $0) }
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
		let session = ApiClient.shared.getSession()
		ArtistsView()
			.environmentObject(ArtistRepository(session: session))
	}
}

struct SelectArtistView: View {
	@State private var searchText = ""
	@State private var loading = false
	@State private var artists: [Artist] = []
	@State private var currentTask: Task<Void, Never>? = nil
	@State private var creating = false
	@State private var multiSelection = Set<String>()
	
	@Environment(\.dismiss) private var dismiss
	
	@EnvironmentObject private var artistRepository: ArtistRepository
	
	let onCreate: (_ artists: [Artist]) -> Void
	
	var body: some View {
		NavigationView {
			VStack {
				if loading {
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.padding()
				} else {
					List(artists, id: \.sptfArtistId, selection: $multiSelection) {
						ArtistView(name: $0.name, imageUrl: $0.images.first?.url ?? "")
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
						addSelectedArtists()
					} label: {
						if creating {
							ProgressView()
						} else {
							Text("Adicionar \(multiSelection.count)")
								.bold()
						}
					}
					.disabled(multiSelection.count == 0)
				}
			}
			.navigationTitle("Selecionar artista")
			.navigationBarTitleDisplayMode(.inline)
			.task { debounceQuery() }
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
				await query()
			}
		}
	}
	
	private func query() async {
		loading = true
		do {
			if searchText.isEmpty {
				artists = try await artistRepository.suggestions().filter({ $0.id == nil })
			} else {
				artists = try await artistRepository.search(query: searchText).filter({ $0.id == nil })
			}
		} catch {
			print("Canno`t search artists. \(error)")
		}
		loading = false
	}
	
	
	private func addSelectedArtists() {
		Task {
			creating = true
			do {
				let addedArtists = try await artistRepository.create(sptfArtistIds: Array(multiSelection))
				onCreate(addedArtists)
				dismiss()
			} catch {
				
			}
			creating = false
		}
	}
}
