//
//  ArtistRepository.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation

import Alamofire

class ArtistRepository : ObservableObject {
    
    private let session: Session
    
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
