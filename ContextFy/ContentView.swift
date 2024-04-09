//
//  ContentView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var authIsPresented = false
    
    @AppStorage("spotify.access_token") private var accessToken: String = ""
    
    var body: some View {
        if accessToken.isEmpty {
            NavigationView {
                VStack {
                    Button {
                        authIsPresented = true
                    } label: {
                        Text("Entrar com spotify")
                    }
                }
                .padding()
                .navigationTitle("ContextFy")
                .sheet(isPresented: $authIsPresented, content: {
                    NavigationView {
                        SpotifyAuthWebView() { result in
                            authIsPresented = false
                            guard let accessToken = result.accessToken else {
                                return
                            }
                            // User is authenticated
                            self.accessToken = accessToken
                        }
                        .navigationTitle("Entrar com spotify")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button {
                                    authIsPresented = false
                                } label: {
                                    Text("Cancelar")
                                }
                            }
                        }
                    }
                })
            }
        } else {
            NavigationView {
                VStack {
                    Text("Você está autenticado")
                        .padding()
                    Button {
                        showAccessToken()
                    } label: {
                        Text("Printar Token de Accesso")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(role: .destructive) {
                            self.accessToken = ""
                        } label: {
                            Text("Sair da aplicação")
                        }
                    }
                }
            }
        }
    }
    
    private func showAccessToken() {
        if let token = UserDefaults.standard.string(forKey: "spotify.access_token") {
            print(token)
        }
    }
}

#Preview {
    ContentView()
}
