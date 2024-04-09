//
//  ContentView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @AppStorage("spotify.access_token") private var accessToken: String = ""
    
    var body: some View {
        if accessToken.isEmpty {
            AuthView()
        } else {
            ContainerView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SpotifyService())
}
