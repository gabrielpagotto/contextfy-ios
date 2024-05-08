//
//  HomeView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct HomeView: View {
    @State private var firstArtistSelectionIsPresented = false
    @State private var addNewContextIsPresented = false
    @State private var rateTrackIsPresented = true
    @State private var newContextName = ""
    
    var body: some View {
        NavigationView {
            List {
                Section() {
                    Label("Recomendações para \"Casa\"", systemImage: "beats.headphones")
                        .bold()
                        .padding(.leading)
                }
                
                // TODO: Change this for a real data
                ForEach(0..<50) { i in
                    TrackView(
                        name: "Decida",
                        artistName: "Milionário e José Rico",
                        albumName: "Atravessando Gerações",
                        albumImageUrl: "https://i.scdn.co/image/ab67616d0000b273ed96587b9a84f44f2f115a2e", playing: i == 1)
                }
            }
            .navigationTitle("ContextFy")
            .alert("Novo contexto detectado",  isPresented: $addNewContextIsPresented) {
                TextField("Nome", text: $newContextName)
                Button {
                } label: {
                    Text("Adicionar")
                        .bold()
                }
                .disabled(newContextName.isEmpty)
                Button(role: .cancel) {
                    
                } label: {
                    Text("Cancelar")
                }
            } message: {
                Text("Informe o nome de onde você está, para que seja adicionado o novo contexto.")
            }
            .alert("Avalie essa música", isPresented: $rateTrackIsPresented) {
                HStack {
                    Text("😔")
                    Text("😔")
                    Text("😔")
                }
                Button {
                     
                } label: {
                    Text("OK")
                }
            } message: {
               
            }
            .sheet(isPresented: $firstArtistSelectionIsPresented) {
                FirstArtistSelectionView()
            }
        }
    }
}

#Preview {
    HomeView()
}
