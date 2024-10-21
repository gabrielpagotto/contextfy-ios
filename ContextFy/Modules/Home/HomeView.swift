//
//  HomeView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
	@State private var addNewContextIsPresented = false
	@State private var playerIsPresented = false
	@State private var playingIndex: Int? = nil
	
	@State private var latitude = nil as Double?
	@State private var longitude = nil as Double?
	@State private var isRunningLocationListener: Bool = false
	
	@StateObject private var locationManager = LocationManager()
	
	@EnvironmentObject private var homeController: HomeController
	@EnvironmentObject private var contextRepository: ContextRepository
	@EnvironmentObject private var artistRepository: ArtistRepository
	
	var body: some View {
		NavigationView {
			List {
				Section {
					Text("\(String(describing: latitude)) - \(String(describing: longitude))")
				}
				Section {
					if locationManager.authorizationStatus == .notDetermined  {
						HStack {
							ProgressView()
							Text("Aguardando ativação de localização...")
								.bold()
								.padding(.leading)
						}
					} else if locationManager.authorizationStatus == .denied {
						HStack {
							Image(systemName: "exclamationmark.triangle.fill")
								.foregroundStyle(.red)
							Text("Localização indisponível")
								.bold()
								.padding(.leading)
							Spacer()
							Button("Permitir") {
								if let url = URL(string: UIApplication.openSettingsURLString) {
									if UIApplication.shared.canOpenURL(url) {
										UIApplication.shared.open(url, options: [:], completionHandler: nil)
									}
								}
							}
						}
						
					} else if [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) {
						if homeController.context == nil {
							Button {
								addNewContextIsPresented = true
							} label: {
								Text("Adicionar este contexto")
							}
						} else {
							Label("Recomendações para \"\(homeController.context!.name)\"", systemImage: "beats.headphones")
								.bold()
								.padding(.leading)
						}
					}
				}
				
				
				// TODO: Change this for a real data
				ForEach(0..<50) { i in
					TrackView(
						name: "Decida",
						artistName: "Milionário e José Rico",
						albumName: "Atravessando Gerações",
						albumImageUrl: "https://i.scdn.co/image/ab67616d0000b273ed96587b9a84f44f2f115a2e", playing: i == playingIndex,
						onPlayPressed: {
							if playingIndex == i {
								playingIndex = nil
							} else {
								playingIndex = i
							}
						}
					)
				}
			}
			.navigationTitle("ContextFy")
			.toolbar {
				if playingIndex != nil {
					ToolbarItem(placement: .bottomBar) {
						HStack(alignment: .top) {
							CachedImageView(urlString: "https://i.scdn.co/image/ab67616d0000b273ed96587b9a84f44f2f115a2e")
								.frame(width: 40, height: 40)
								.cornerRadius(Constants.defaultCornerRadius)
							VStack(alignment: .leading) {
								Text("Decida")
								Text("Milionário e José Rico")
									.foregroundColor(.secondary)
									.font(.subheadline)
							}
							Spacer()
							Button {
							} label: {
								Image(systemName: "pause")
									.foregroundColor(.primary)
							}
							.controlSize(.mini)
						}
						.onTapGesture {
							playerIsPresented = true
						}
					}
				}
			}
			.sheet(isPresented: $addNewContextIsPresented) {
				AddContextView(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
					.presentationDetents([.medium])
			}
			.sheet(isPresented: $homeController.firstGenderAndArtistSelectionPresented) {
				NavigationView {
					FirstGenderSelectionView()
				}
			}
			.sheet(isPresented: $playerIsPresented) {
				PlayerView()
			}
		}
		.onAppear(perform: startLocationListener)
		.onDisappear {
			isRunningLocationListener = false
		}
		.onChange(of: locationManager.location) {
			self.latitude = $1?.coordinate.latitude
			self.longitude = $1?.coordinate.longitude
		}
		.task {
			if let artists = try? await artistRepository.all() {
				if artists.isEmpty {
					homeController.firstGenderAndArtistSelectionPresented = true
				}
			}
		}
	}
	
	func startLocationListener() {
		guard !isRunningLocationListener else { return }
		isRunningLocationListener = true
		Task {
			while isRunningLocationListener {
				guard !addNewContextIsPresented else {
					try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
					continue
				}
				
				guard latitude != nil && longitude != nil else {
					homeController.context = nil
					try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
					continue
				}
				
				guard let context = try? await contextRepository.current(latitude: latitude!, longitude: longitude!, radius: 5) else {
					homeController.context = nil
					continue
				}
				
				homeController.context = context
				try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
			}
		}
	}
	
	func loadInitialContext() {
		
	}
}

#Preview {
	HomeView()
		.environmentObject(HomeController())
}
