//
//  MapViewState.swift
//  CityGuide
//
//  Created by David Procházka on 08.04.2026.
//

import SwiftUI
import MapKit

@Observable
class MapViewState {
    var cameraPosition: MapCameraPosition = .camera(
        .init(
            centerCoordinate: .init(latitude: 49.209, longitude: 16.614),
            distance: 3000
        )
    )
    var mapItems: [MapItem] = []
    var selectedMapItem: MapItem? = nil
}
