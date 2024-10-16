//
//  SelectArtistsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 16/10/24.
//

import SwiftUI


struct SelectArtistsView: View {
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

#Preview {
	SelectArtistsView { artists in
		
	}
}
