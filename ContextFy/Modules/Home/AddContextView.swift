//
//  AddContextView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 17/10/24.
//

import SwiftUI

struct AddContextView: View {
	let latitude: Double
	let longitude: Double
	
	@State private var newContextName = ""
	@State private var creating = false
	
	@Environment(\.dismiss) private var dismiss
	
	@EnvironmentObject private var homeController: HomeController
	@EnvironmentObject private var contextRepository: ContextRepository
	
	
	var body: some View {
		NavigationView {
			List {
				Section(footer: Text("Informe o nome de onde você está, para que seja adicionado o novo contexto.")) {
					TextField("Nome do contexto", text: $newContextName)
					
				}
				Section {
					Button {
						create()
					} label: {
						if creating {
							HStack {
								ProgressView()
								Text("Adicionando...")
									.padding()
							}
						} else {
							Text("Adicionar")
						}
					}
					.bold()
					.disabled(newContextName.count < 1 || creating)
					
					Button(role: .destructive) {
						
					} label: {
						Text("Cancelar")
					}
				}
			}
			.navigationTitle("Novo contexto detectado")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
	
	func create() {
		Task {
			creating = true
			do {
				let context = try await contextRepository.create(name: newContextName, latitude: latitude, longitude: longitude)
				newContextName = ""
				homeController.context = context
				newContextName = ""
				dismiss()
			} catch {
				
			}
			creating = false
		}
	}
}

#Preview {
	AddContextView(latitude: 0, longitude: 0)
}
