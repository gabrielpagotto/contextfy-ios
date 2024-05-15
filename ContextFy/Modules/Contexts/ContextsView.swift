//
//  ContextsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 07/05/24.
//

import SwiftUI

struct ContextsView: View {
    
    let contexts = [
        "Casa",
        "Trabalho",
        "Academia"
    ]
    
    var body: some View {
        List {
            Section(footer: Text("Seus contextos aparecerão aqui. Sempre que você começar a ouvir uma música em um novo local por um tempo determinado, será perguntado se você gostaria de adicionar o novo contexto.")) {
                ForEach(contexts, id: \.self) {
                    Text($0)
                }
                .onDelete(perform: { indexSet in
                    
                })
            }

        }
        .navigationTitle("Meus contextos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ContextsView()
    }
}
