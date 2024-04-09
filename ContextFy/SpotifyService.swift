//
//  SpotifyService.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import Foundation

class SpotifyService {
    
    static let shared = SpotifyService()
    
    func getAccessTokenUrl() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = SpotifyConstants.authHost
        components.path = "/authorize"
        components.queryItems = SpotifyConstants.authParams.map({ URLQueryItem(name: $0, value: $1) })
        
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}
