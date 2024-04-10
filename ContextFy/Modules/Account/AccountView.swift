//
//  SettingsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct AccountView: View {
    @AppStorage("spotify.access_token") private var accessToken = ""
    @AppStorage("spotify.display_name") private var displayName = ""
    @AppStorage("spotify.image_url") private var imageUrl = ""
    
    @State private var logoutConfirmationIsPresented = false
    
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
        logoutConfirmationIsPresented = false
        UserDefaults.standard.removeObject(forKey: "spotify.access_token")
        UserDefaults.standard.removeObject(forKey: "spotify.display_name")
        UserDefaults.standard.removeObject(forKey: "spotify.image_url")
    }
}

#Preview {
    AccountView()
}
