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
		let session = ApiClient.shared.getSession()
		WindowGroup {
			ContentView()
				.environmentObject(ProfileRepository(session: session))
				.environmentObject(ArtistRepository(session: session))
				.environmentObject(GenderRepository(session: session))
				.preferredColorScheme(.dark)
			
				.onAppear {
					UIView.appearance().tintColor = UIColor(named: "AccentColor")
				}
		}
	}
}
