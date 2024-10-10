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
            VStack(alignment: .leading) {
                Text("Bem-vindo ao ContextFy!")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 4)
                
                Text("Sua trilha sonora personalizada, onde quer que você esteja.")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                
                Button {
                    spotifyAuthWebviewPresented = true
                } label: {
                    Text("Entrar no Spotify")
                        .bold()
                }
                .buttonStyle(.custom)
                .padding(.top, 64)
            }
            .padding()
            .sheet(isPresented: $spotifyAuthWebviewPresented, content: {
                NavigationView {
                    AuthWebView(authURL: "http://localhost:3000/auth/spotify/oauth2", onResult: authenticate)
                        .navigationTitle("Entrar no Spotify")
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
        
        var imageUrl = ""
        if let images = profile?.images {
            var iSize = 0
            for image in images {
                let nSize = image.width + image.height
                if nSize > iSize {
                    iSize = nSize
                    imageUrl = image.url
                }
            }
        }
        print(imageUrl)
        self.imageUrl = imageUrl
    }
}

private struct CustomButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.medium)
            .padding(.vertical, 12)
            .foregroundColor(.white)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.accent, in: .rect(cornerRadius: 14, style: .continuous))
            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
}

extension ButtonStyle where Self == CustomButtonStyle {
    static var custom: CustomButtonStyle { .init() }
}

#Preview {
    AuthView()
        .environmentObject(SpotifyService())
}
