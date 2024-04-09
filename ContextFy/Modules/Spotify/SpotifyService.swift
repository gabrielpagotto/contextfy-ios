//
//  SpotifyService.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import Foundation
import SwiftUI

@MainActor
class SpotifyService: ObservableObject {
    
    private let client = HttpClient(
        scheme: "https",
        host: SpotifyConstants.apiHost,
        keyDecodingStrategy: .convertFromSnakeCase
    )
    
    init() {
        self.client.addMiddleware(middleware: { request in
            if let token = UserDefaults.standard.string(forKey: "spotify.access_token") {
                var request = request
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                return request
            }
            return request
        })
    }
    
    func getAccessTokenUrl() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = SpotifyConstants.authHost
        components.path = "/authorize"
        components.queryItems = SpotifyConstants.authParams.map({ URLQueryItem(name: $0, value: $1) })
        
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
    
    func getProfile() throws -> SpotifyProfile {
        return try client.get("/v1/me")
    }
}
