//
//  ArtistRepository.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation
import Alamofire
import SwiftUI

protocol ArtistRepositoryProtocol {
	func all() async throws -> [Artist]
	func suggestions() async throws -> [Artist]
	func search(query: String) async throws -> [Artist]
	func create(sptfArtistIds: [String]) async throws -> [Artist]
	func delete(id: Int) throws -> Void
}

final class ArtistRepository : ArtistRepositoryProtocol, ObservableObject {
	
	var session: Session
	
	init(session: Session) {
		self.session = session
	}
	
	func all() async throws -> [Artist] {
		let response = await session.request("/artists")
			.validate().serializingDecodable([Artist].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func suggestions() async throws -> [Artist] {
		let response = await session.request("/artists/suggestions")
			.validate().serializingDecodable([Artist].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func search(query: String) async throws -> [Artist] {
		let response = await session.request("/artists/search", parameters: ["q": query])
			.validate().serializingDecodable([Artist].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func create(sptfArtistIds: [String]) async throws -> [Artist] {
		let body: [String: Any] = [
			"sptf_artist_ids": sptfArtistIds
		]
		let response = await session.request(
			"/artists",
			method: .post,
			parameters: body,
			encoding: JSONEncoding.default
		).validate().serializingDecodable([Artist].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func delete(id: Int) throws {
		_ = session.request("/artists/\(id)", method: .delete)
			.validate()
			.response { response in
				switch response.result {
				case .success:
					break
				case .failure(let error):
					Task { throw error }
				}
			}
	}
}


final class ArtistRepositoryPreview: ArtistRepositoryProtocol {
	var artists: [Artist] = [
		Artist(id: 1, sptfArtistId: "487N2T9nIPEHrlTZLL3SQs", name: "Zé Neto & Cristiano", images: [
			SptfImage(url: "https://i.scdn.co/image/ab6761610000e5eb7098ffe23a919f7742979c6e", height: 640, width: 640)
		], genres: [
			"agronejo",
			"arrocha",
			"sertanejo",
			"sertanejo universitario"
		])
	]
	
	func search(query: String) async throws -> [Artist] {
		return artists
	}
	
	func create(sptfArtistIds: [String]) async throws -> [Artist] {
		artists.append(artists.first!)
		return [artists.last!]
	}
	
	func delete(id: Int) throws {
		
	}
	
	func all() async throws -> [Artist] {
		return artists
	}
	
	func suggestions() async throws -> [Artist] {
		return artists
	}
}

