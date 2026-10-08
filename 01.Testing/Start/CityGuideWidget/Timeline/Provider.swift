//
//  Provider.swift
//  CityGuide
//
//  Created by David Procházka on 12.05.2026.
//

import WidgetKit
import CoreLocation

struct Provider: AppIntentTimelineProvider {
    let locationManager: LocationManaging
    
    init() {
        locationManager = DIContainer.shared.resolve()
    }
    
    func placeholder(in context: Context) -> LocationEntry {
        LocationEntry(
            date: Date(),
            configuration: ConfigurationAppIntent(),
            coordinates: .init(latitude: 46.6, longitude: 17.7),
            locationName: "Brno"
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> LocationEntry {
        LocationEntry(
            date: Date(),
            configuration: configuration,
            coordinates: locationManager.getCurrentLocation(),
            locationName: locationManager.getCurrentLocationName()
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<LocationEntry> {
        var entries: [LocationEntry] = []

        let entry = LocationEntry(
            date: Date(),
            configuration: configuration,
            coordinates: locationManager.getCurrentLocation(),
            locationName: locationManager.getCurrentLocationName()
        )
        entries.append(entry)

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}
