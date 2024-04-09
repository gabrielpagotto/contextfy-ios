//
//  HttpClient.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import Foundation

class HttpClient {
    let scheme: String
    let host: String
    let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    
    
    private var middlewares: [(_ request: URLRequest) -> URLRequest] = []
    
    init(scheme: String, host: String, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) {
        self.scheme = scheme
        self.host = host
        self.keyDecodingStrategy = keyDecodingStrategy
    }
    
    private func getApiUrlComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        return components
    }
    
    func addMiddleware(middleware: @escaping (_ request: URLRequest) -> URLRequest) {
        middlewares.append { request in
            middleware(request)
        }
    }
    
    func get<T: Decodable>(_ path: String) throws -> T {
        var components = getApiUrlComponents()
        components.path = path
        
        guard let url = components.url else {
            throw HttpClientError(message: nil, status: nil, type: .invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        for middleware in middlewares {
            request = middleware(request)
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        var responseData: T?
        var requestError: HttpClientError?
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            
            if let error = error {
                requestError = HttpClientError(message: error.localizedDescription, status: nil, type: .unknown)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                requestError = HttpClientError(message: "Unknown", status: nil, type: .unknown)
                return
            }
            
            if httpResponse.statusCode > 299 {
                requestError = HttpClientError(message: data?.debugDescription, status: httpResponse.statusCode, type: .badStatus)
                return
            }
            
            do {
                guard let data = data else {
                    requestError = HttpClientError(message: "No data received", status: nil, type: .noData)
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = self.keyDecodingStrategy
                responseData = try decoder.decode(T.self, from: data)
            } catch {
                requestError = HttpClientError(message: "Cold not parse", status: nil, type: .parse)
            }
        }.resume()
        semaphore.wait()
        
        if let requestError = requestError {
            throw requestError
        }
        
        guard let unwrappedResponseData = responseData else {
            throw HttpClientError(message: "No response data", status: nil, type: .noData)
        }
        return unwrappedResponseData
    }
}

enum HttoClientErroType {
    case invalidURL
    case badStatus
    case noData
    case parse
    case unknown
}

struct HttpClientError: Error {
    let message: String?
    let status: Int?
    let type: HttoClientErroType
}
