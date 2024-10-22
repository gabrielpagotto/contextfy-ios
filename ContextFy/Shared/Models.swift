//
//  Models.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation

struct SptfImage: Decodable, Identifiable, Equatable {
	let url: String
	let height: Int
	let width: Int
	
	var id: String { url }
}


struct Profile: Decodable, Identifiable, Equatable {
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

struct Artist: Decodable, Identifiable, Equatable {
	let id: Int?
	let sptfArtistId: String
	let name: String
	let images: [SptfImage]
	let genres: [String]
	
	enum CodingKeys: String, CodingKey {
		case id
		case sptfArtistId = "sptf_artist_id"
		case name
		case images
		case genres
	}
}

struct Gender: Decodable, Identifiable, Equatable {
	let id: Int?
	let sptfGenderId: String
	let name: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case sptfGenderId = "sptf_gender_id"
		case name
	}
}

struct ContextModel: Decodable, Identifiable, Equatable {
	let id: Int
	let name: String
	let latitude: Double
	let longitude: Double
}

struct TrackArtistModel: Decodable, Identifiable, Equatable {
	let sptfArtistId: String
	let name: String
	
	var id: String { sptfArtistId }
	
	enum CodingKeys: String, CodingKey {
		case sptfArtistId = "sptf_artist_id"
		case name
	}
}

struct RatedTrackModel: Decodable, Identifiable, Equatable  {
	let id: Int
	let contextId: Int
	let userId: Int
	let rate: Int
	
	enum CodingKeys: String, CodingKey {
		case id
		case contextId = "context_id"
		case userId = "user_id"
		case rate
	}
}

struct TrackModel: Decodable, Identifiable, Equatable {
	let sptfTrackId: String
	let name: String
	let previewUrl: String
	let uri: String
	let type: String
	let images: [SptfImage]
	let artists: [TrackArtistModel]
	var rate: RatedTrackModel?
	
	var id: String { sptfTrackId }
	
	enum CodingKeys: String, CodingKey {
		case sptfTrackId = "sptf_track_id"
		case name
		case previewUrl = "preview_url"
		case uri
		case type
		case images
		case artists
		case rate
	}
}
