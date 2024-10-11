//
//  ContainerView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(HomeController())
                .tabItem {
                    Label("Início", systemImage: "music.note.house")
                }
            AccountView()
                .tabItem {
                    Label("Minha conta", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContainerView()
}
