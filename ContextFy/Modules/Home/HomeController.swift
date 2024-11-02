//
//  HomeController.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation
import CoreLocation

@MainActor
final class HomeController : ObservableObject {
	
	private let artistRepository: any ArtistRepositoryProtocol
	private let contextRepository: any ContextRepositoryProtocol
	private let recommendationRepository: any RecommendationRepositoryProtocol
	
	@Published var addNewContextIsPresented = false
	@Published var playerIsPresented = false
	@Published var playingIndex: Int? = nil
	
	@Published var latitude = nil as Double?
	@Published var longitude = nil as Double?
	@Published var isRunningLocationListener: Bool = false
	
	@Published var firstGenderAndArtistSelectionPresented = false
	@Published var context = nil as ContextModel?
	
	@Published var isLoadingRecommendations = true
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
				self.recommendations = try await recommendationRepository.getRecommendations(contextId: context!.id)
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
				guard !addNewContextIsPresented else {
					try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
					continue
				}
				
				guard latitude != nil && longitude != nil else {
					self.context = nil
					self.isLoadingRecommendations = false
					try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
					continue
				}
				
				try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
				guard let context = try? await contextRepository.current(latitude: latitude!, longitude: longitude!, radius: 5) else {
					self.context = nil
					self.isLoadingRecommendations = false
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
	
	func previousTrack(for currentTrack: TrackModel) -> TrackModel? {
		guard let currentIndex = recommendations.firstIndex(where: { $0.id == currentTrack.id }) else {
			return nil
		}
		let previousIndex = currentIndex - 1
		guard previousIndex >= 0 else {
			return nil
		}
		return recommendations[previousIndex]
	}
	
	func nextTrack(for currentTrack: TrackModel) -> TrackModel? {
		guard let currentIndex = recommendations.firstIndex(where: { $0.id == currentTrack.id }) else {
			return nil
		}
		let nextIndex = currentIndex + 1
		guard nextIndex < recommendations.count else {
			return nil
		}
		return recommendations[nextIndex]
	}
}
