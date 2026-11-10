//
//  CityGuideWatchApp.swift
//  CityGuide Watch App
//
//  Created by David Procházka on 06.10.2026.
//

import SwiftUI

@main
struct CityGuideWatchApp: App {
    // the connector is created once, at app start, and handed to the view model
    @State private var viewModel = PlacesViewModel(connector: Connector())

    var body: some Scene {
        WindowGroup {
            PlacesListView(viewModel: viewModel)
        }
    }
}
