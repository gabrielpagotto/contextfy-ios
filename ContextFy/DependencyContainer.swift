//
//  DependencyContainer.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 20/10/24.
//

import SwiftUI

@MainActor
final class DependencyContainer : ObservableObject {
	let session = ApiClient.shared.getSession()
	
	lazy var artistsRepository: ArtistRepository = .init(session: session)
	lazy var contextRepository: ContextRepository = .init(session: session)
	lazy var profileRepository: ProfileRepository = .init(session: session)
	lazy var genderRepository: GenderRepository = .init(session: session)
	lazy var recommendationRepository: RecommendationRepository = .init(session: session)
	lazy var ratedTrackRepository: RatedTrackRepository = .init(session: session)
	lazy var playlistRepository: PlaylistRepository = .init(session: session)
	
	
	lazy var homeViewModel: HomeController = {
		return .init(artistRepository: artistsRepository,
					 contextRepository: contextRepository,
					 recommendationRepository: recommendationRepository)
	}()
	
	lazy var artistsViewModel: ArtistsViewModel = {
		return .init(artistRepository: artistsRepository)
	}()
	
	lazy var playerViewModel: PlayerViewModel = {
		return .init(ratedTrackRepository: ratedTrackRepository)
	}()
	
	lazy var playlistsViewModel: PlaylistsViewModel = {
		return .init(playlistRepository: playlistRepository)
	}()
}
