//
//  SettingsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct AccountView: View {
	@AppStorage("contextfy.access_token") private var accessToken = ""
	@AppStorage("contextfy.display_name") private var displayName = ""
	@AppStorage("contextfy.image_url") private var imageUrl = ""
	
	@State private var logoutConfirmationIsPresented = false
	
	@EnvironmentObject private var dependencyContainer: DependencyContainer
	@EnvironmentObject private var playerViewModel: PlayerViewModel
	
	var body: some View {
		NavigationView {
			List {
				Section(footer: Text("Imagem e nome de usuário do Spotify.")) {
					HStack {
						VStack {
							CachedImageView(urlString: imageUrl, placeholderSystemName: "person.crop.circle")
								.scaledToFit()
						}
						.background(.secondary)
						.foregroundColor(.white)
						.frame(width: 60)
						.clipShape(Circle())
						
						Text(displayName)
							.bold()
							.font(.title3)
							.padding(.leading)
					}
				}
				
				Section {
					NavigationLink {
						ArtistsView()
							.environmentObject(dependencyContainer.makeArtistsViewModel())
					} label: {
						Label("Artistas", systemImage: SystemIcons.artists)
					}
					NavigationLink {
						GendersView()
					} label: {
						Label("Gêneros", systemImage: SystemIcons.genders)
					}
					NavigationLink {
						ContextsView()
					} label: {
						Label("Meus contextos", systemImage: SystemIcons.contexts)
					}
					NavigationLink {
						PlaylistsView()
					} label: {
						Label("Playlists", systemImage: SystemIcons.playlists)
					}
				}
				
				// Logout button
				Button(role: .destructive) {
					logoutConfirmationIsPresented = true
				} label: {
					Text("Sair do aplicativo")
				}
				.alert("Sair do aplicativo?", isPresented: $logoutConfirmationIsPresented) {
					Button(role: .destructive) { logout() } label: { Text("Sair") }
						.foregroundColor(.accentColor)
				}
			}
			.navigationTitle("Minha Conta")
		}
	}
	
	private func logout() {
		playerViewModel.playingTrack = nil
		logoutConfirmationIsPresented = false
		UserDefaults.standard.removeObject(forKey: "contextfy.access_token")
		UserDefaults.standard.removeObject(forKey: "contextfy.display_name")
		UserDefaults.standard.removeObject(forKey: "contextfy.image_url")
	}
}

#Preview {
	AccountView()
}
