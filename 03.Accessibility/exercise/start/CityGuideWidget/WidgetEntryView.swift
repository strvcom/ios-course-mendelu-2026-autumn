//
//  WidgetEntryView.swift
//  CityGuide
//
//  Created by David Procházka on 12.05.2026.
//
import SwiftUI
import CoreLocation

struct CityGuideWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            if let coordinates = entry.coordinates {
                Text("Location: ")
                Text("Lat: \(coordinates.latitude), Lon: \(coordinates.longitude)")
            } else {
                Text("Default location: ")
                Text("Lat: \(entry.configuration.defaultLatitude),                   Lon: \(entry.configuration.defaultLongitude)")
            }
            
            if let locationName = entry.locationName {
                Text("Location name: \(locationName)")
            } else {
                Text("Default location")
            }
        }
    }
}
