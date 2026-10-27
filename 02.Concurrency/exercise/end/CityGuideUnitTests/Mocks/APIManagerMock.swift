//
//  APIManagerMock.swift
//  CityGuide
//
//  Created by Martina Stremenova on 19.10.2026.
//

import Foundation
@testable import CityGuide

final class APIManagerMock: APIManaging {
    
    let returnValue: Result<Decodable, Error>
    
    init(returnValue: Result<Decodable, Error>) {
        self.returnValue = returnValue
    }
    
    func request<T>(_ endpoint: any CityGuide.Router) async throws -> T where T : Decodable {
        switch returnValue {
        case .success(let decodable):
            guard let result = decodable as? T else {
                throw NSError(domain: "ApiManagerMockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to cast to expected type \(T.self)"])
            }
            return result
        case .failure(let error):
            throw error
        }
    }
}
