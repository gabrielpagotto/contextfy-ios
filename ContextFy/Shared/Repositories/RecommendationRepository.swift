//
//  RecommendationRepository.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 20/10/24.
//

import Foundation
import Alamofire

protocol RecommendationRepositoryProtocol {
	func getRecommendations(contextId: Int) async throws -> [TrackModel]
}

final class RecommendationRepository : RecommendationRepositoryProtocol, ObservableObject {
	
	var session: Session
	
	init(session: Session) {
		self.session = session
	}
	
	func getRecommendations(contextId: Int) async throws -> [TrackModel] {
		let response = await session.request("/recommendations", parameters: ["context_id": contextId])
			.validate().serializingDecodable([TrackModel].self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
}
