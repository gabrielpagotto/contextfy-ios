//
//  FirstArtistSelectionView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 07/05/24.
//

import SwiftUI

struct FirstArtistSelectionView: View {
    
    @State private var searchText = ""
    @State private var loading = false
    @State private var multiSelection = Set<String>()
    @State private var artists: [Artist] = []
    @State private var currentTask: Task<Void, Never>? = nil
    @State private var creating = false
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var homeController: HomeController
    @EnvironmentObject private var artistRepository: ArtistRepository
    
    
    var body: some View {
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
        .navigationTitle("Artistas")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    addSelectedArtists()
                } label: {
                    if creating {
                        ProgressView()
                    } else {
                        Text("Concluir")
                            .bold()
                    }
                }
                .disabled(multiSelection.count < 3 || creating)
            }
            ToolbarItem(placement: .bottomBar) {
                VStack {
                    Text("\(multiSelection.count) selecionados")
                    Text("Selecione ao menos 3 artistas para continuar.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task { debounceQuery() }
        .onChange(of: searchText, { Task { debounceQuery() } })
        .environment(\.editMode, .constant(EditMode.active))
        .interactiveDismissDisabled(true)
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
                artists = try await artistRepository.suggestions()
            } else {
                artists = try await artistRepository.search(query: searchText)
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
                let _ = try await artistRepository.create(sptfArtistIds: Array(multiSelection))
                homeController.firstGenderAndArtistSelectionPresented = false
            } catch {
                
            }
            creating = false
        }
    }
}

#Preview {
    NavigationView {
        FirstArtistSelectionView()
            .environmentObject(HomeController())
    }
}
