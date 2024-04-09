//
//  HomeView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Você está autenticado")
                    .padding()
                Button {
                    
                } label: {
                    Text("Printar Token de Accesso")
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(role: .destructive) {
//                        self.accessToken = ""
                    } label: {
                        Text("Sair da aplicação")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
