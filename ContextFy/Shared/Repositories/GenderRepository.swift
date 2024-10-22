//
//  GenderRepository.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 16/10/24.
//

import Foundation
import Alamofire

protocol GenderRepositoryProtocol {
	func all() async throws -> [Gender]
	func suggestions() async throws -> [Gender]
	func create(sptfGenderIds: [String]) async throws -> [Gender]
	func delete(id: Int) async throws
}

final class GenderRepository : GenderRepositoryProtocol, ObservableObject {
	
	var session: Session
	
	init(session: Session) {
		self.session = session
	}
	
	func all() async throws -> [Gender] {
		let response = await session.request("/genres")
			.validate().serializingDecodable([Gender].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func suggestions() async throws -> [Gender] {
		let response = await session.request("/genres/suggestions")
			.validate().serializingDecodable([Gender].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func create(sptfGenderIds: [String]) async throws -> [Gender] {
		let body: [String: Any] = [
			"sptf_gender_ids": sptfGenderIds
		]
		let response = await session.request(
			"/genres",
			method: .post,
			parameters: body,
			encoding: JSONEncoding.default
		).validate().serializingDecodable([Gender].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func delete(id: Int) async throws {
		_ = session.request("/genres/\(id)", method: .delete)
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
