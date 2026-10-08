//
//  DataManaging.swift
//  CityGuide
//
//  Created by David Procházka on 08.04.2026.
//

import Foundation

protocol DataManaging {
    func savePlace(_ item: MapItem)
    func fetchPlaces() -> [MapItem]
}
