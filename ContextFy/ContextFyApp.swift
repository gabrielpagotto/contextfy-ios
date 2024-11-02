//
//  ContextFyApp.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

@main
struct ContextFyApp: App {
	var body: some Scene {
		let dependencyContainer: DependencyContainer = .init()
		let session = dependencyContainer.session
		WindowGroup {
			ContentView()
				.environmentObject(dependencyContainer)
				.environmentObject(dependencyContainer.playerViewModel)
				.environmentObject(ProfileRepository(session: session))
				.environmentObject(ArtistRepository(session: session))
				.environmentObject(GenderRepository(session: session))
				.environmentObject(ContextRepository(session: session))
				.environmentObject(RecommendationRepository(session: session))
				.preferredColorScheme(.dark)
			
				.onAppear {
					UIView.appearance().tintColor = UIColor(named: "AccentColor")
				}
		}
	}
}
