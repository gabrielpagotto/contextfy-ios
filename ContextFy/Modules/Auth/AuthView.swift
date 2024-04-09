//
//  Auth.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct AuthView: View {
    @State private var spotifyAuthWebviewPresented = false
    
    @EnvironmentObject private var spotifyService: SpotifyService
    
    @AppStorage("spotify.access_token") private var accessToken: String = ""
    @AppStorage("spotify.display_name") private var displayName: String = ""
    @AppStorage("spotify.image_url") private var imageUrl: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    spotifyAuthWebviewPresented = true
                } label: {
                    Text("Entrar com spotify")
                }
            }
            .padding()
            .navigationTitle("ContextFy")
            .sheet(isPresented: $spotifyAuthWebviewPresented, content: {
                NavigationView {
                    SpotifyAuthWebView(spotifyService: spotifyService, onResult: authenticate)
                        .navigationTitle("Entrar com spotify")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button {
                                    spotifyAuthWebviewPresented = false
                                } label: {
                                    Text("Cancelar")
                                }
                            }
                        }
                }
            })
        }
    }
    
    private func authenticate(_ result: AuthResult) {
        spotifyAuthWebviewPresented = false
        
        if let accessToken = result.accessToken {
            self.accessToken = accessToken
        }
        
        let profile = try? spotifyService.getProfile()
        if let displayName = profile?.displayName {
            self.displayName = displayName
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(SpotifyService())
}
