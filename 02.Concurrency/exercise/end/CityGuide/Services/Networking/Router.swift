//
//  Router.swift
//  CityGuide
//
//  Created by Martin Vidovic on 05.05.2026.
//

import Foundation

// https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=48.48&daily=temperature_2m_max

protocol Router {
    var host: String { get } // "https://api.open-meteo.com"
    var path: String { get } // "v1/forecast"
    var method: HttpMethod { get } // GET
    var urlParameters: [String: Any]? { get } // "latitude=52.52&longitude=48.48&daily=temperature_2m_max"
    var headers: [String: String] { get } // [:]

    func asRequest() throws -> URLRequest
}

extension Router {
    func asRequest() throws -> URLRequest {
        guard let host = URL(string: host) else {
            throw APIError.invalidHost
        }
        
        let urlPath = host.appending(path: path)
        guard var urlComponents = URLComponents(url: urlPath, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidURLComponents
        }
        
        if let urlParameters {
            urlComponents.queryItems = urlParameters.map({ (key, value) in
                URLQueryItem(name: key, value: String(describing: value))
            })
        }
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURLComponents
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        print("🛜 \(request)")
        return request
    }
}

enum APIError: Error {
    case invalidHost
    case invalidURLComponents
    case noResponse
    case unacceptableResponseStatusCode
}
