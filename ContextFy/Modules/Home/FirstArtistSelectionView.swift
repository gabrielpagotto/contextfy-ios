//
//  FirstArtistSelectionView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 07/05/24.
//

import SwiftUI

struct FirstArtistSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var searchText = ""
    @State private var multiSelection = Set<Int>()
    
    
    var body: some View {
        NavigationView {
            List(0..<10, id: \.self, selection: $multiSelection) { index in
                ArtistView(name: "Milionário e José Rico", imageUrl: "https://i.scdn.co/image/ab6761610000e5eb26c5c8d56a8979c644f37de7")
            }
            .navigationTitle("Artistas")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Concluir")
                            .bold()
                    }
                    .disabled(multiSelection.count < 3)
                }
                ToolbarItem(placement: .bottomBar) {
                    VStack {
                        Text("\(multiSelection.count) selecionados")
                        Text("Selecione ao menos 3 artistas para continuar.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .environment(\.editMode, .constant(EditMode.active))
            .interactiveDismissDisabled(true)
        }
    }
}

#Preview {
    FirstArtistSelectionView()
}
