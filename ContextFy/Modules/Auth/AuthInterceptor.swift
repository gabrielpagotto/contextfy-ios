//
//  AuthInterceptor.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation
import Alamofire

final class AuthInterceptor : RequestInterceptor {
	
	private func removeAccessToken() {
		UserDefaults.standard.removeObject(forKey: "contextfy.access_token")
	}
	
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
	
	func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
		if let response = request.task?.response as? HTTPURLResponse {
			if [401, 500].contains(response.statusCode) { removeAccessToken() }
		}
		completion(.doNotRetry)
	}
}
