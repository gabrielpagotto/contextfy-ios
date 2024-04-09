//
//  SettingsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct AccountView: View {
    @AppStorage("spotify.display_name") private var displayName = "Gabrielpagotto"
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: Text("Imagem e nome de usuário do Spotify.")) {
                    HStack {
                        Text(displayName)
                    }
                }
                
                // Logout button
                Button(role: .destructive) {
                    // TODO: Implement logout
                } label: {
                    Text("Sair do aplicativo")
                }
            }
            .navigationTitle("Configurações")
        }
    }
}

#Preview {
    AccountView()
}
