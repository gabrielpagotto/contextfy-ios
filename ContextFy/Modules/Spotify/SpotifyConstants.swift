//
//  APIConstants.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import Foundation

enum SpotifyConstants {
    static let apiHost = "api.spotify.com"
    static let authHost = "accounts.spotify.com"
    static let clientID = "32719c0e79af41f68efd36ff156ec3f1"
    static let clientSecret = "6e893b895057419a869fc70291fdcbb2"
    static let redirectURI = "https://www.google.com"
    static let responseType = "token"
    static let scopes = "user-read-private"
    
    static let authParams = ["response_type": responseType, "client_id": clientID, "redirect_uri": redirectURI, "scopes": scopes]
}
