//
//  ContainerView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct ContainerView: View {
	@EnvironmentObject private var dependencyContainer: DependencyContainer
	
	
	var body: some View {
		TabView {
			HomeView()
				.environmentObject(dependencyContainer.makeHomeViewModel())
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
