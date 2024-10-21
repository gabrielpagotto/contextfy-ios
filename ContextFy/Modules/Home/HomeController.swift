//
//  HomeController.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation
import CoreLocation

@MainActor
class HomeController : ObservableObject {
	
	let artistRepository: any ArtistRepositoryProtocol
	let contextRepository: any ContextRepositoryProtocol
	let recommendationRepository: any RecommendationRepositoryProtocol
	
	@Published var addNewContextIsPresented = false
	@Published var playerIsPresented = false
	@Published var playingIndex: Int? = nil
	
	@Published var latitude = nil as Double?
	@Published var longitude = nil as Double?
	@Published var isRunningLocationListener: Bool = false
	
	@Published var firstGenderAndArtistSelectionPresented = false
	@Published var context = nil as ContextModel?
	
	@Published var isLoadingRecommendations = false
	@Published var recommendations: [TrackModel] = []
	
	init(
		artistRepository: any ArtistRepositoryProtocol,
		contextRepository: any ContextRepositoryProtocol,
		recommendationRepository: any RecommendationRepositoryProtocol) {
		self.artistRepository = artistRepository
		self.contextRepository = contextRepository
		self.recommendationRepository = recommendationRepository
	}
	
	@Sendable
	func loadArtists() async -> Void {
		if let artists = try? await artistRepository.all() {
			if artists.isEmpty {
				firstGenderAndArtistSelectionPresented = true
			}
		}
	}
	
	func loadRecommendations() {
		Task {
			do {
				isLoadingRecommendations = true
				self.recommendations = try await recommendationRepository.getRecommendations()
			} catch {
				print("Canno`t load recommendations: \(error)")
			}
			isLoadingRecommendations = false
		}
	}
	
	func updateLocation(location: CLLocation? ) {
		latitude = location?.coordinate.latitude
		longitude = location?.coordinate.longitude
	}
	
	func startLocationListener() {
		guard !isRunningLocationListener else { return }
		isRunningLocationListener = true
		Task {
			while isRunningLocationListener {
				try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
				guard !addNewContextIsPresented else {
					continue
				}
				
				guard latitude != nil && longitude != nil else {
					self.context = nil
					continue
				}
				
				guard let context = try? await contextRepository.current(latitude: latitude!, longitude: longitude!, radius: 5) else {
					self.context = nil
					continue
				}
				
				self.context = context
				try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
			}
		}
	}
	
	func cancelLocationListener() {
		isRunningLocationListener = false
	}
}
