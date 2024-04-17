//
//  UserPreferencesView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 15/04/24.
//

import SwiftUI

private enum ScreenMode {
    case artists
    case genders
}

struct UserPreferencesView: View {
    @State private var screenMode: ScreenMode = .artists
    @State private var addArtistIsPresented = false
    @State private var addGenderIsPresented = false
    
    var body: some View {
        NavigationView {
            List {
                if screenMode == .artists {
                    // TODO: Change this for a real data
                    ForEach(0..<50) { i in
                        ArtistView(name: "Europe", imageUrl: "https://i.scdn.co/image/ab67616d0000b2732d925cec3072ed1b74e5188f")
                    }.onDelete(perform: { indexSet in
                        // TODO: Implement delete
                    })
                } else if screenMode == .genders {
                    // TODO: Change this for a real data
                    ForEach(0..<50) { i in
                        Text("Rock")
                    }.onDelete(perform: { indexSet in
                        // TODO: Implement delete
                    })
                }
            }
            .toolbar {
                
                // Screen mode selector
                ToolbarItem(placement: .principal) {
                    Picker("Screen type", selection: $screenMode) {
                        Text("Artistas").tag(ScreenMode.artists)
                        Text("Genêros").tag(ScreenMode.genders)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                }
                
                // Select new artists and genders button
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        
                        // Add new artists button
                        Button {
                            addArtistIsPresented = true
                        } label: {
                            Label("Adicionar artistas", systemImage: "")
                        }
                        
                        // Add new genders button
                        Button {
                            addGenderIsPresented = true
                        } label: {
                            Label("Adicionar genêros", systemImage: "")
                        }
                    } label: {
                        Label("", systemImage: "plus.circle")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    UserPreferencesView()
}
