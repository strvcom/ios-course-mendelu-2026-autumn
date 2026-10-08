//
//  PlacesViewModel.swift
//  CityGuide Watch App
//
//  Created by David Procházka on 06.10.2026.
//

import SwiftUI

@Observable
final class PlacesViewModel {
    var state = PlacesViewState()

    private var dataManager: DataManaging
    private let connector: Connector

    init(connector: Connector) {
        self.connector = connector
        dataManager = DIContainer.shared.resolve()

        // a place sent from the iPhone: store it and show it
        connector.onPlaceReceived = { [weak self] place in
            self?.dataManager.savePlace(place)
            self?.fetchPlaces()
        }
    }

    var isPhoneReachable: Bool {
        connector.isReachable
    }

    func fetchPlaces() {
        state.places = dataManager.fetchPlaces()
    }
}
