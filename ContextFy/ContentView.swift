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
    
    var body: some View {
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
                        print(result.accessToken!)
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
    }
}

#Preview {
    ContentView()
}
