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
                .preferredColorScheme(.dark)
            
                // This fix the dialogs foreground and background colors
                .onAppear {
                    UIView.appearance().tintColor = UIColor(named: "AccentColor")
//                    UIView.appearance().backgroundColor = .black
                }
        }
    }
}
