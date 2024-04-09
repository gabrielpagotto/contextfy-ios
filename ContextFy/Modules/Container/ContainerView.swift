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
                .tabItem {
                    Label("Início", systemImage: "home")
                }
            AccountView()
                .tabItem {
                    Label("Configurações", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContainerView()
}
