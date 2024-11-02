//
//  ContextsView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 07/05/24.
//

import SwiftUI
import MapKit

struct ContextsView: View {
	
	@State private var loading = true
	@State private var contexts: [ContextModel] = []
	@State private var selectedContext: ContextModel? = nil
	
	@EnvironmentObject private var contextRepository: ContextRepository
	
	var body: some View {
		VStack {
			if loading {
				ProgressView()
			} else {
				if contexts.isEmpty {
					ContentUnavailableView(
						"Nenhum contexto adicionado",
						systemImage: SystemIcons.contexts,
						description: Text("Quando você estiver em um novo local, adicione um novo contexto na tela inicial."))
				} else {
					List {
						Section(footer: Text("Seus contextos aparecerão aqui. Você pode clicar no nome para visualizar o mapa.")) {
							ForEach(contexts, id: \.id) { context in
								Button {
									selectedContext = context
								} label: {
									Text(context.name)
								}
								.foregroundStyle(.primary)
							}
							.onDelete(perform: deleteContext)
						}
					}
				}
			}
		}
		.onAppear(perform: loadContexts)
		.navigationTitle("Meus contextos")
		.navigationBarTitleDisplayMode(.inline)
		.sheet(isPresented: .constant(selectedContext != nil), onDismiss: { selectedContext = nil }) {
			NavigationView {
				VStack {
					if selectedContext != nil {
						MapView(markers: contexts.map({ context in
							Marker(
								coordinate: CLLocationCoordinate2D(latitude: context.latitude, longitude: context.longitude),
								name: context.name,
								isPrimary: context.id == selectedContext!.id
							)
						}))
					}
				}
				.navigationTitle("Localização de \(selectedContext?.name ?? "")")
				.navigationBarTitleDisplayMode(.inline)
			}
			.presentationDetents([.medium])
			.presentationDragIndicator(.visible)
		}
	}
	
	private func loadContexts() {
		Task {
			loading = true
			do {
				contexts = try await contextRepository.all()
			} catch {
				print("Error on load contexts. \(error)")
			}
			loading = false
		}
	}
	
	private func deleteContext(_ indexSet: IndexSet) {
		for index in indexSet {
			Task {
				do {
					try contextRepository.delete(id: contexts[index].id)
					contexts.remove(at: index)
				} catch {
					print("Error on remove context. \(error)")
				}
			}
		}
	}
}

struct MapView: View {
	
	let markers: [Marker]
	
	@State private var region: MKCoordinateRegion
	
	init(markers: [Marker]) {
		self.markers = markers
		_region = State(initialValue: MKCoordinateRegion(
			center: markers.first(where: { marker in marker.isPrimary })!.coordinate,
			span: MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001)
		))
	}
	
	var body: some View {
		Map(coordinateRegion: $region, annotationItems: markers) { marker in
			MapAnnotation(coordinate: marker.coordinate) {
				VStack {
					if marker.isPrimary {
						Image(systemName: "mappin.and.ellipse")
							.font(.title)
							.foregroundStyle(.red)
					} else {
						Image(systemName: "mappin")
							.font(.title2)
					}
					Text(marker.name)
						.font(.caption)
						.padding(4)
						.background(.background)
						.foregroundStyle(.primary)
						.cornerRadius(8)
				}
			}
		}
		.edgesIgnoringSafeArea(.bottom)
	}
}

struct Marker: Identifiable {
	let id = UUID()
	let coordinate: CLLocationCoordinate2D
	let name: String
	let isPrimary: Bool
}


#Preview {
	NavigationView {
		ContextsView()
	}
}
