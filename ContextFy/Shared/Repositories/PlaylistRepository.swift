//
//  PlaylistRepository.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 02/11/24.
//


import Foundation
import Alamofire
import SwiftUI

protocol PlaylistRepositoryProtocol {
	func all() async throws -> [Playlist]
	func suggestions() async throws -> [Playlist]
	func search(query: String) async throws -> [Playlist]
	func create(sptfArtistIds: [String]) async throws -> [Playlist]
	func delete(id: Int) throws -> Void
}

final class PlaylistRepository : PlaylistRepositoryProtocol, ObservableObject {
	
	var session: Session
	
	init(session: Session) {
		self.session = session
	}
	
	func all() async throws -> [Playlist] {
		let response = await session.request("/playlists")
			.validate().serializingDecodable([Playlist].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func suggestions() async throws -> [Playlist] {
		let response = await session.request("/playlists/suggestions")
			.validate().serializingDecodable([Playlist].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func search(query: String) async throws -> [Playlist] {
		let response = await session.request("/playlists/search", parameters: ["q": query])
			.validate().serializingDecodable([Playlist].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func create(sptfArtistIds: [String]) async throws -> [Playlist] {
		let body: [String: Any] = [
			"sptf_playlist_ids": sptfArtistIds
		]
		let response = await session.request(
			"/playlists",
			method: .post,
			parameters: body,
			encoding: JSONEncoding.default
		).validate().serializingDecodable([Playlist].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}

	func delete(id: Int) throws {
		_ = session.request("/playlists/\(id)", method: .delete)
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
