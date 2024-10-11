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
            SelectArtistView()
        }
        .onAppear(perform: query)
    }
    
    private func query() {
        Task {
            loading = true
            do {
                artists = try await artistRepository.all()
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

struct SelectArtistView: View {
    @State private var search = ""
    
    @Environment(\.dismiss) private var dismiss
    @State private var multiSelection = Set<Int>()
    
    var body: some View {
        NavigationView {
            List(0..<50, id: \.self, selection: $multiSelection) { i in
                ArtistView(name: "Milionário e José Rico", imageUrl: "https://i.scdn.co/image/ab6761610000e5eb26c5c8d56a8979c644f37de7")
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
                        dismiss()
                    } label: {
                        Text("Adicionar \(multiSelection.count)")
                            .disabled(multiSelection.count == 0)
                    }
                }
            }
            .navigationTitle("Selecionar artista")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $search)
            .environment(\.editMode, .constant(EditMode.active))
            .interactiveDismissDisabled(true)
        }
    }
}
