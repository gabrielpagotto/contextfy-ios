//
//  RatedTrackRepository.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 21/10/24.
//

import Foundation
import Alamofire

protocol RatedTrackRepositoryProtocol {
	func rate(rate: Int, contextId: Int, sptfTrackId: String) async throws -> RatedTrackModel
}

final class RatedTrackRepository : RatedTrackRepositoryProtocol {
	
	var session: Session
	
	init(session: Session) {
		self.session = session
	}
	
	func rate(rate: Int, contextId: Int, sptfTrackId: String) async throws -> RatedTrackModel {
		let body: [String: Any] = [
			"rate": rate,
			"context_id": contextId,
			"sptf_track_id": sptfTrackId,
		]
		let response = await session.request(
			"/rates/track/toggle",
			method: .post,
			parameters: body,
			encoding: JSONEncoding.default
		).validate().serializingDecodable(RatedTrackModel.self).response
		switch response.result {
		case .success(let result):
			return result
		case .failure(let error):
			throw error
		}
	}
}
