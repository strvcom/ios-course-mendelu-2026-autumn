//
//  WeatherData.swift
//  CityGuide
//
//  Created by Martin Vidovic on 05.05.2026.
//

import Foundation

struct WeatherData: Codable {
    let daily: Daily
}

struct Daily: Codable {
    let time: [String]
    let maxTemperatures: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case maxTemperatures = "temperature_2m_max"
    }
}
