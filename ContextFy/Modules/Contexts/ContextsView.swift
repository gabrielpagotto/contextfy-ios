//
//  ContextsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 07/05/24.
//

import SwiftUI

struct ContextsView: View {
	
	@State private var loading = true
	@State private var contexts: [ContextModel] = []
	
	@EnvironmentObject private var contextRepository: ContextRepository

    var body: some View {
        List {
			if loading {
				ProgressView()
			} else {
				Section(footer: Text("Seus contextos aparecerão aqui. Sempre que você começar a ouvir uma música em um novo local por um tempo determinado, será perguntado se você gostaria de adicionar o novo contexto.")) {
					ForEach(contexts, id: \.id) {
						Text($0.name)
					}
					.onDelete(perform: deleteContext)
				}
			}
        }
		.onAppear(perform: loadContexts)
        .navigationTitle("Meus contextos")
        .navigationBarTitleDisplayMode(.inline)
    }
	
	private func loadContexts() {
		Task {
			loading = true
			do {
				contexts = try await contextRepository.all()
			} catch {
				print("Error on load contexts. \(error)")
			}
			loading = false
		}
	}
	
	private func deleteContext(_ indexSet: IndexSet) {
		for index in indexSet {
			Task {
				do {
					try contextRepository.delete(id: contexts[index].id)
					contexts.remove(at: index)
				} catch {
					print("Error on remove context. \(error)")
				}
			}
		}
	}
}

#Preview {
    NavigationView {
        ContextsView()
    }
}
