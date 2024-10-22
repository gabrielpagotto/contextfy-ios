//
//  ArtistsViewModel.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 21/10/24.
//

import Foundation

@MainActor
final class ArtistsViewModel : ObservableObject {
	
	private let artistRepository: any ArtistRepositoryProtocol
	
	@Published var isLoading = false
	@Published var isCreating = false
	@Published var isSearching = false
	@Published var artists: [Artist] = []
	@Published var searchedArtists: [Artist] = []
	
	@Published var isSelectingArtists = false
	
	init(artistRepository: any ArtistRepositoryProtocol) {
		self.artistRepository = artistRepository
	}
	
	func startArtistSelection() -> Void {
		isSelectingArtists = true
	}
	
	func loadArtists() async -> Void {
		do {
			isLoading = true
			artists = try await artistRepository.all()
		} catch {
			print("Error loading artists. \(error)")
		}
		isLoading = false
	}
	
	func create(ids: Set<String>) async -> Void {
		do {
			isCreating = true
			let addedArtists = try await artistRepository.create(sptfArtistIds: Array(ids))
			artists.append(contentsOf: addedArtists)
			isSelectingArtists = false
		} catch {
			print("Error creating artist: \(error)")
		}
		isCreating = false
	}
	
	func deleteArtist(at indexSet: IndexSet) async -> Void {
		guard let index = indexSet.first else { return }
		let artistToDelete = artists[index]
		do {
			try artistRepository.delete(id: artistToDelete.id!)
			artists.remove(at: index)
		} catch {
			print("Error deleting artist: \(error)")
		}
		
	}
	
	func searchArtists(query: String) async -> Void {
		do {
			isSearching = true
			if query.isEmpty {
				searchedArtists = try await artistRepository.suggestions().filter({ $0.id == nil })
			} else {
				searchedArtists = try await artistRepository.search(query: query).filter({ $0.id == nil })
			}
		} catch {
			print("Error searching artists. \(error)")
		}
		isSearching = false
	}
}
