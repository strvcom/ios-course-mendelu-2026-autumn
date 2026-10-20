//
//  WeatherDataRouter.swift
//  CityGuide
//
//  Created by Martin Vidovic on 05.05.2026.
//

import Foundation

enum WeatherDataRouter {
    case dailyMaxTemperature(long: Double, lat: Double)
}

// if you want to see API documentation, open `open-meteo.com`
//https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=48.48&daily=temperature_2m_max

extension WeatherDataRouter: Router {
    var host: String {
        "https://api.open-meteo.com"
    }
    
    var path: String {
        "v1/forecast"
    }
    
    var method: HttpMethod {
        switch self {
        case .dailyMaxTemperature:
            .get
        }
    }
    
    var urlParameters: [String : Any]? {
        switch self {
        case let .dailyMaxTemperature(long: long, lat: lat):
            [
                "longitude": long,
                "latitude": lat,
                "daily": "temperature_2m_max"
            ]
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .dailyMaxTemperature:
            [:]
        }
    }
}
