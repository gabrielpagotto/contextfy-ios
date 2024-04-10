//
//  SpotifyModels.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import Foundation

struct SpotifyProfile: Codable {
    let id: String
    let displayName: String
    let href: String
    let type: String
    let uri: String
    let images: [SpotifyImage]
}

struct SpotifyImage: Codable {
    let url: String
    let height: Int
    let width: Int
}
