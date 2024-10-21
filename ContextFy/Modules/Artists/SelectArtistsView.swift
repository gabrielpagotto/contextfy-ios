//
//  SelectArtistsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 16/10/24.
//

import SwiftUI


struct SelectArtistsView: View {
	@State private var searchText = ""
	@State private var currentTask: Task<Void, Never>? = nil
	@State private var multiSelection = Set<String>()
	
	@Environment(\.dismiss) private var dismiss
	
	@EnvironmentObject private var artistsViewModel: ArtistsViewModel
	
	var body: some View {
		NavigationView {
			VStack {
				if artistsViewModel.isSearching {
					LoaderView()
				} else {
					List(artistsViewModel.searchedArtists, id: \.sptfArtistId, selection: $multiSelection) {
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
						Task { await artistsViewModel.create(ids: multiSelection) }
					} label: {
						if artistsViewModel.isCreating {
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
			.navigationTitle("Selecionar artista")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear { Task { await artistsViewModel.searchArtists(query: "") } }
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
				await artistsViewModel.searchArtists(query: searchText)
			}
		}
	}
}

#Preview {
	SelectArtistsView()
}
