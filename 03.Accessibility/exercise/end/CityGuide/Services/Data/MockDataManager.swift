//
//  MockDataManager.swift
//  CityGuide
//
//  Created by David Procházka on 08.04.2026.
//

import Foundation
import CoreLocation
import UIKit

final class MockDataManager: DataManaging {
    private var storage: [MapItem] = []

    init() {
        self.storage.append(MapItem.getSample())
    }

    func savePlace(_ item: MapItem) {
        if let index = storage.firstIndex(where: { $0.id == item.id }) {
            storage[index] = item
        } else {
            storage.append(item)
        }
    }

    func fetchPlaces() -> [MapItem] {
        return storage
    }
}
