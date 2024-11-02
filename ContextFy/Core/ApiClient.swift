//
//  ApiClient.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation
import Alamofire

final private class BaseURLInterceptor: RequestInterceptor {
	
	private let baseURL: String
	
	init(baseURL: String) {
		self.baseURL = baseURL
	}
	
	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
		guard let url = urlRequest.url, !url.absoluteString.hasPrefix("http") else {
			completion(.success(urlRequest))
			return
		}
		var urlRequest = urlRequest
		if let completeURL = URL(string: baseURL + url.absoluteString) { urlRequest.url = completeURL }
		completion(.success(urlRequest))
	}
}

class ApiClient {
	static let baseURL = "http://127.0.0.1:3000"
	
	static let shared: ApiClient = {
		let instance = ApiClient()
		return instance
	}()
	
	private init() { }
	
	private lazy var session: Session = {
		let baseURLInterceptor = BaseURLInterceptor(baseURL: ApiClient.baseURL)
		let authInterceptor = AuthInterceptor()
		let authMonitor = AuthMonitor()
		return Session(interceptor: Interceptor(adapters: [authInterceptor, baseURLInterceptor]), eventMonitors: [authMonitor])
	}()
	
	func getSession() -> Session { return session }
}
