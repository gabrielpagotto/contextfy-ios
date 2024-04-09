//
//  ContextFyApp.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

@main
struct ContextFyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SpotifyService())
        }
    }
}
