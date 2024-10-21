//
//  DependencyContainer.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 20/10/24.
//

import SwiftUI

@MainActor
final class DependencyContainer : ObservableObject {
	lazy var session = ApiClient.shared.getSession()
	
	lazy var artistsRepository: ArtistRepository = .init(session: session)
	lazy var contextRepository: ContextRepository = .init(session: session)
	lazy var profileRepository: ProfileRepository = .init(session: session)
	lazy var genderRepository: GenderRepository = .init(session: session)
	lazy var recommendationRepository: RecommendationRepository = .init(session: session)
		
	func makeHomeViewModel() -> HomeController {
		return HomeController(artistRepository: artistsRepository,
							  contextRepository: contextRepository,
							  recommendationRepository: recommendationRepository)
	}
	
	func makeArtistsViewModel() -> ArtistsViewModel {
		return ArtistsViewModel(artistRepository: artistsRepository)
	}
}
