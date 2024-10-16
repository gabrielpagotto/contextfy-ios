//
//  FirstGenderSelectionView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 14/05/24.
//

import SwiftUI

struct FirstGenderSelectionView: View {
	@Environment(\.dismiss) private var dismiss
	
	
	@State private var loading = false
	@State private var genres: [Gender] = []
	@State private var multiSelection = Set<String>()
	@EnvironmentObject private var genderRepository: GenderRepository
	
//	private var filteredGenres: [Gender] {
//		guard !searchText.isEmpty else { return genres }
//		return genres.filter({ $0.name.localizedCaseInsensitiveContains(searchText) })
//	}
	
	var body: some View {
		VStack {
			if loading {
				ProgressView()
			} else {
				List(genres, id: \.sptfGenderId, selection: $multiSelection) {
					Text($0.name)
				}
			}
		}
		.navigationTitle("Gêneros")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				NavigationLink {
					FirstArtistSelectionView(selectedGenres: $multiSelection)
				} label: {
					Text("Próximo")
						.bold()
				}
				.disabled(multiSelection.count < 3)
			}
			ToolbarItem(placement: .bottomBar) {
				VStack {
					Text("\(multiSelection.count) selecionados")
					Text("Selecione ao menos 3 gêneros para continuar.")
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
			}
		}
		.task { await query() }
		.environment(\.editMode, .constant(EditMode.active))
		.interactiveDismissDisabled(true)
	}
	
	private func query() async {
		loading = true
		do {
			genres = try await genderRepository.suggestions()
		} catch {
			print("Canno`t search genres. \(error)")
		}
		loading = false
	}
}

#Preview {
	NavigationView {
		FirstGenderSelectionView()
	}
}
