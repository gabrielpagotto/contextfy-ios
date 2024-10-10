//
//  Auth.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct AuthView: View {
    @State private var spotifyAuthWebviewPresented = false
    
    @EnvironmentObject private var profileRepository: ProfileRepository
    @EnvironmentObject private var spotifyService: SpotifyService
    
    @AppStorage("contextfy.access_token") private var accessToken: String = ""
    @AppStorage("contextfy.display_name") private var displayName: String = ""
    @AppStorage("contextfy.image_url") private var imageUrl: String = ""
    
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
        if let accessToken = result.accessToken { self.accessToken = accessToken }
        Task {
            do {
                let profile = try await profileRepository.me()
                await MainActor.run {
                    var imageUrl = ""
                    var iSize = 0
                    for image in profile.images {
                        let nSize = image.width + image.height
                        if nSize > iSize {
                            iSize = nSize
                            imageUrl = image.url
                        }
                    }
                    self.displayName = profile.displayName
                    self.imageUrl = imageUrl
                }
            } catch {
                self.accessToken = ""
                print("Failed to fetch profile: \(error.localizedDescription)")
            }
            spotifyAuthWebviewPresented = false
        }
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
