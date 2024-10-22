//
//  ContextRepository.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 17/10/24.
//

import Foundation
import Alamofire

protocol ContextRepositoryProtocol {
	func all() async throws -> [ContextModel]
	func current(latitude: Double, longitude: Double, radius: Int) async throws -> ContextModel
	func create(name: String, latitude: Double, longitude: Double) async throws -> ContextModel
	func delete(id: Int) throws
}

final class ContextRepository : ContextRepositoryProtocol, ObservableObject {
	
	var session: Session
	
	init(session: Session) {
		self.session = session
	}
	
	func all() async throws -> [ContextModel] {
		let response = await session.request("/contexts")
			.validate().serializingDecodable([ContextModel].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func current(latitude: Double, longitude: Double, radius: Int) async throws -> ContextModel {
		let response = await session.request("/contexts/current", parameters: [
			"latitude": latitude,
			"longitude": longitude,
			"radius": radius
		]).validate().serializingDecodable(ContextModel.self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func create(name: String, latitude: Double, longitude: Double) async throws -> ContextModel {
		let body: [String: Any] = [
			"name": name,
			"latitude": latitude,
			"longitude": longitude,
		]
		let response = await session.request(
			"/contexts",
			method: .post,
			parameters: body,
			encoding: JSONEncoding.default
		).validate().serializingDecodable(ContextModel.self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
	
	func delete(id: Int) throws {
		_ = session.request("/contexts/\(id)", method: .delete)
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
