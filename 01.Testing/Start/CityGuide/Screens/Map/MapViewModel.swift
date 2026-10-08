//
//  MapViewModel.swift
//  CityGuide
//
//  Created by David Procházka on 01.04.2026.
//

import SwiftUI
import MapKit

@Observable
class MapViewModel {
     var state: MapViewState = MapViewState()
    
    private var dataManager: DataManaging
    private var locationManager: LocationManaging

    init() {
        dataManager = DIContainer.shared.resolve()
        locationManager = DIContainer.shared.resolve()
    }
    
    func fetchMapItems() {
        state.mapItems = dataManager.fetchPlaces()
    }
    
    func fetchUserLocation() {
        if let possiblyNewLocation = locationManager.getCurrentLocation(),
            let oldLocation = state.cameraPosition.camera?.centerCoordinate {
            
            if possiblyNewLocation.latitude != oldLocation.latitude ||
               possiblyNewLocation.longitude != oldLocation.longitude {
                state.cameraPosition = .camera(
                    .init(
                        centerCoordinate: possiblyNewLocation,
                        distance: 3000
                    )
                )
            }
        }
    }
}

