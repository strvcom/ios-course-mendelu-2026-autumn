//
//  NewMapItemViewModel.swift
//  CityGuide
//
//  Created by David Prochazka on 21.04.2026.
//

import SwiftUI
import CoreLocation
import PhotosUI

@Observable
class NewMapItemViewModel {
    var state = NewMapItemViewModelState()
    private var dataManager: DataManaging
    private var locationManager: LocationManaging
 
    init() {
        dataManager = DIContainer.shared.resolve()
        locationManager = DIContainer.shared.resolve()
        
        if let location = locationManager.getCurrentLocation() {
            state.locationCoordinates = location
        }
    }
    
    func addMapItem() {
        let newItem = MapItem(
            id: UUID(),
            coordinate: state.locationCoordinates,
            title: state.locationName,
            style: state.locationStyle,
            type: state.locationType,
            image: state.locationImage
        )
        
        dataManager.savePlace(newItem)
    }
}
