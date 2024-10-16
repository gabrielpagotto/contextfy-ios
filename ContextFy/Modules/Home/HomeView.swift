//
//  HomeView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct HomeView: View {
    @State private var addNewContextIsPresented = false
    @State private var newContextName = ""
    @State private var playerIsPresented = false
    
    @State private var playingIndex: Int? = nil
    
    @EnvironmentObject private var homeController: HomeController
    @EnvironmentObject private var artistRepository: ArtistRepository
    
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
                        albumImageUrl: "https://i.scdn.co/image/ab67616d0000b273ed96587b9a84f44f2f115a2e", playing: i == playingIndex,
                        onPlayPressed: {
                            if playingIndex == i {
                                playingIndex = nil
                            } else {
                                playingIndex = i
                            }
                        }
                    )
                }
            }
            .navigationTitle("ContextFy")
            .toolbar {
                if playingIndex != nil {
                    ToolbarItem(placement: .bottomBar) {
                        HStack(alignment: .top) {
                            CachedImageView(urlString: "https://i.scdn.co/image/ab67616d0000b273ed96587b9a84f44f2f115a2e")
                                .frame(width: 40, height: 40)
                                .cornerRadius(Constants.defaultCornerRadius)
                            VStack(alignment: .leading) {
                                Text("Decida")
                                Text("Milionário e José Rico")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button {
                            } label: {
                                Image(systemName: "pause")
                                    .foregroundColor(.primary)
                            }
                            .controlSize(.mini)
                        }
                        .onTapGesture {
                            playerIsPresented = true
                        }
                    }
                }
            }
            .sheet(isPresented: $addNewContextIsPresented) {
                NavigationView {
                    List {
                        Section(footer: Text("Informe o nome de onde você está, para que seja adicionado o novo contexto.")) {
                            TextField("Nome do contexto", text: $newContextName)
                            
                        }
                        Section {
                            Button {
                                
                            } label: {
                                Text("Adicionar")
                            }
                            .bold()
                            .disabled(newContextName.count < 1)
                            
                            Button(role: .destructive) {
                                
                            } label: {
                                Text("Cancelar")
                            }
                        }
                    }
                    .navigationTitle("Novo contexto detectado")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $homeController.firstGenderAndArtistSelectionPresented) {
                NavigationView {
                    FirstGenderSelectionView()
                }
            }
            .sheet(isPresented: $playerIsPresented) {
                PlayerView()
            }
        }
        .task {
            if let artists = try? await artistRepository.all() {
                if artists.isEmpty {
                    homeController.firstGenderAndArtistSelectionPresented = true
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeController())
}
