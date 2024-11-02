//
//  PlaylistsViewModel.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 02/11/24.
//

import Foundation

@MainActor
final class PlaylistsViewModel : ObservableObject {
	
	private let playlistRepository: any PlaylistRepositoryProtocol
	
	@Published var isLoading = false
	@Published var isCreating = false
	@Published var isSearching = false
	@Published var playlists: [Playlist] = []
	@Published var searchedPlaylists: [Playlist] = []
	
	@Published var isSelectingPlaylists = false
	
	init(playlistRepository: any PlaylistRepositoryProtocol) {
		self.playlistRepository = playlistRepository
	}
	
	func startPlaylistSelection() -> Void {
		isSelectingPlaylists = true
	}
	
	func loadPlaylists() async -> Void {
		do {
			isLoading = true
			playlists = try await playlistRepository.all()
		} catch {
			print("Error loading playlists. \(error)")
		}
		isLoading = false
	}
	
	func createPlaylist(ids: Set<String>) async -> Void {
		do {
			isCreating = true
			let addedPlaylist = try await playlistRepository.create(sptfArtistIds: Array(ids))
			playlists.append(contentsOf: addedPlaylist)
			isSelectingPlaylists = false
		} catch {
			print("Error creating playlist: \(error)")
		}
		isCreating = false
	}
	
	func deletePlaylist(at indexSet: IndexSet) async -> Void {
		guard let index = indexSet.first else { return }
		let playlistToDelete = playlists[index]
		do {
			try playlistRepository.delete(id: playlistToDelete.id!)
			playlists.remove(at: index)
		} catch {
			print("Error deleting playlist: \(error)")
		}
		
	}
	
	func searchPlaylists(query: String) async -> Void {
		do {
			isSearching = true
			if query.isEmpty {
				searchedPlaylists = try await playlistRepository.suggestions().filter({ $0.id == nil })
			} else {
				searchedPlaylists = try await playlistRepository.search(query: query).filter({ $0.id == nil })
			}
		} catch {
			print("Error searching playlists. \(error)")
		}
		isSearching = false
	}
}
