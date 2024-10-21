//
//  GendersView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 14/05/24.
//

import SwiftUI

struct GendersView: View {
	@State private var loaded = false
	@State private var saving = false
	@State private var loading = false
	@State private var selecteds = Set<String>()
	@State private var genres: [Gender] = []
	
	@EnvironmentObject private var genderRepository: GenderRepository

	var body: some View {
		VStack {
			if loading {
				LoaderView()
			} else if genres.isEmpty  {
				
			} else {
				List(genres, id: \.sptfGenderId, selection: $selecteds) {
					Text($0.name)
						.disabled(true)
				}
				.environment(\.editMode, .constant(EditMode.active))
				.onChange(of: selecteds) { previous, next in
					if next.count > previous.count {
						self.create(Array(next.filter({ !previous.contains($0) })))
					} else {
						self.delete(Array(previous.filter({ !next.contains($0) })))
					}
				}
			}
		}
		.navigationTitle("Gêneros")
		.navigationBarTitleDisplayMode(.inline)
		.onAppear { query() }
		.toolbar {
			if saving {
				ToolbarItem {
					HStack {
						ProgressView()
						Text("Salvando")
					}
					.foregroundStyle(.secondary)
				}
			}
		}
	}
	
	private func query() {
		if loaded { return }
		Task {
			loading = true
			do {
				genres = try await genderRepository.suggestions()
				for genre in genres {
					if genre.id == nil { continue }
					selecteds.insert(genre.sptfGenderId)
				}
			} catch {
				print("Canno`t search genres. \(error)")
			}
			loaded = true
			loading = false
		}
	}
	
	private func create(_ sptfGenderIds: [String]) {
		Task {
			self.saving = true
			do {
				for gender in try await genderRepository.create(sptfGenderIds: sptfGenderIds) {
					genres = genres.map({ $0.sptfGenderId == gender.sptfGenderId ? gender : $0 })
				}
			} catch {
				print("Canno`t create genre. \(error)")
			}
			self.saving = false
		}
	}
	
	private func delete(_ sptfGenderIds: [String]) {
		Task {
			self.saving = true
			for sptfGenderId in sptfGenderIds {
				guard let genderToDelete = genres.first(where: { $0.sptfGenderId == sptfGenderId }) else {
					return
				}
				guard let genderId = genderToDelete.id else { return }
				do {
					try await genderRepository.delete(id: genderId)
				} catch {
					print("Canno`t delete genre. \(error)")
				}
			}
			self.saving = false
		}
	}
}

#Preview {
	NavigationView {
		GendersView()
	}
}
