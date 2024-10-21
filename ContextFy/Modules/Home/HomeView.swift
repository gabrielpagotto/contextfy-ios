//
//  HomeView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
	@StateObject private var locationManager = LocationManager()
	
	@EnvironmentObject private var homeController: HomeController
	@EnvironmentObject private var playerViewModel: PlayerViewModel
	
	var body: some View {
		NavigationView {
			List {
				Section {
					Text("\(String(describing: homeController.latitude)) - \(String(describing: homeController.longitude))")
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
								homeController.addNewContextIsPresented = true
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
				ForEach(homeController.recommendations, id: \.sptfTrackId) { track in
					TrackView(
						name: track.name,
						artistName: track.artists.map(\.name).joined(separator: ", "),
						albumName: "At",
						albumImageUrl: track.images.first?.url ?? "",
						playing: playerViewModel.isPlaying && track.id == playerViewModel.playingTrack?.id,
						onPlayPressed: {
							playerViewModel.playingTrack = track
						}
					)
				}
			}
			.navigationTitle("ContextFy")
			.toolbar {
				if playerViewModel.playingTrack != nil {
					ToolbarItem(placement: .bottomBar) {
						HStack(alignment: .top) {
							CachedImageView(urlString: playerViewModel.playingTrack!.images.first?.url ?? "")
								.frame(width: 40, height: 40)
								.cornerRadius(Constants.defaultCornerRadius)
							VStack(alignment: .leading) {
								Text(playerViewModel.playingTrack!.name)
								Text(playerViewModel.playingTrack!.artists.map(\.name).joined(separator: ", "))
									.foregroundColor(.secondary)
									.font(.subheadline)
							}
							Spacer()
							Button {
								playerViewModel.playPauseSong()
							} label: {
								Image(systemName: playerViewModel.isPlaying ? "pause" : "play")
									.foregroundColor(.primary)
							}
							.controlSize(.mini)
						}
						.onTapGesture {
							homeController.playerIsPresented = true
						}
					}
				}
			}
			.sheet(isPresented: $homeController.addNewContextIsPresented) {
				AddContextView(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
					.presentationDetents([.medium])
			}
			.sheet(isPresented: $homeController.firstGenderAndArtistSelectionPresented) {
				NavigationView {
					FirstGenderSelectionView()
				}
			}
			.sheet(isPresented: $homeController.playerIsPresented) {
				PlayerView()
			}
		}
		.onAppear(perform: homeController.startLocationListener)
		.onDisappear(perform: homeController.cancelLocationListener)
		.task(homeController.loadArtists)
		.onChange(of: locationManager.location) { homeController.updateLocation(location: $1)}
		.onChange(of: homeController.context) { homeController.loadRecommendations() }
	}
}

#Preview {
	HomeView()
}
