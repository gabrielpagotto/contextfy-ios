//
//  GendersView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 14/05/24.
//

import SwiftUI

struct GendersView: View {
    @State private var selecteds = Set<String>()

    var body: some View {
        List(Constants.musicalGenders, id: \.self, selection: $selecteds) {
            Text($0)
        }
        .navigationTitle("Gêneros")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.editMode, .constant(EditMode.active))
    }
}

#Preview {
    NavigationView {
        GendersView()
    }
}
