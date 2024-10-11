//
//  ProfileRepository.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 10/10/24.
//

import Foundation
import Alamofire

class ProfileRepository : ObservableObject {
    
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func me() async throws -> Profile {
        let response = await session.request("/profile/me")
            .validate().serializingDecodable(Profile.self).response
        switch response.result {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }
}
