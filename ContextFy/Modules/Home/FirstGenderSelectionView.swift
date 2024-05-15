//
//  FirstGenderSelectionView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 14/05/24.
//

import SwiftUI

struct FirstGenderSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var searchText = ""
    @State private var multiSelection = Set<String>()
    
    
    var body: some View {
        List(Constants.musicalGenders, id: \.self, selection: $multiSelection) {
            Text($0)
        }
        .navigationTitle("Gêneros")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink {
                    FirstArtistSelectionView()
                } label: {
                    Text("Próximo")
                        .bold()
                }
                .disabled(multiSelection.count < 3)
            }
            ToolbarItem(placement: .bottomBar) {
                VStack {
                    Text("\(multiSelection.count) selecionados")
                    Text("Selecione ao menos 3 gêneros para continuar.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .environment(\.editMode, .constant(EditMode.active))
        .interactiveDismissDisabled(true)
    }
}

#Preview {
    NavigationView {
        FirstGenderSelectionView()
    }
}
