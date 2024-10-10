//
//  Models.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation

struct Profile: Decodable {
    let id: String
    let displayName: String
    let href: String
    let type: String
    let uri: String
    let images: [SptfImage]
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case href
        case type
        case uri
        case images
    }
}

struct SptfImage: Decodable {
    let url: String
    let height: Int
    let width: Int
}
