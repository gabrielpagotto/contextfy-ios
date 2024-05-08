//
//  UserPreferencesView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 15/04/24.
//

import SwiftUI

struct UserPreferencesView: View {
    @State private var search = ""
    @State private var selectArtistIsPresented = false
    
    var body: some View {
        List {
            ForEach(0..<50) { i in
                ArtistView(name: "Milionário e José Rico", imageUrl: "https://i.scdn.co/image/ab6761610000e5eb26c5c8d56a8979c644f37de7")
            }.onDelete(perform: { indexSet in
                // TODO: Implement delete
            })
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    selectArtistIsPresented = true
                } label: {
                    Text("Selecionar")
                }
            }
            
        }
        .navigationTitle("Preferências do usuário")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $search)
        .sheet(isPresented: $selectArtistIsPresented) {
            SelectArtistView()
        }
    }
}

#Preview {
    NavigationView {
        UserPreferencesView()
    }
}

struct SelectArtistView: View {
    @State private var search = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<50) { i in
                    ArtistView(name: "Milionário e José Rico", imageUrl: "https://i.scdn.co/image/ab6761610000e5eb26c5c8d56a8979c644f37de7")
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
            }
            .navigationTitle("Selecionar artista")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $search)
        }
    }
}
