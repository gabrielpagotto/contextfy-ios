//
//  AuthInterceptor.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation
import Alamofire

final class AuthInterceptor : RequestInterceptor {
	
	private func getAccessToken() -> String? {
		return UserDefaults.standard.string(forKey: "contextfy.access_token")
	}
	
	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
		var urlRequest = urlRequest
		if let accessToken = getAccessToken() {
			urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		}
		completion(.success(urlRequest))
	}
}

final class AuthMonitor: EventMonitor {
	private func removeAccessToken() {
		UserDefaults.standard.removeObject(forKey: "contextfy.access_token")
	}

	func requestDidFinish(_ request: Request) {
		if let statusCode = request.response?.statusCode, statusCode == 401 || statusCode == 500 {
			print("Intercepted status code \(statusCode) before Alamofire validation")
			removeAccessToken()
		}
	}
}
