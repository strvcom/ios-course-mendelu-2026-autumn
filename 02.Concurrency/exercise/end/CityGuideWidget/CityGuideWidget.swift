//
//  CityGuideWidget.swift
//  CityGuideWidget
//
//  Created by David Procházka on 12.05.2026.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct CityGuideWidget: Widget {
    let kind: String = "CityGuideWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CityGuideWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("CityGuide Widget")
        .description("Widget with current location and nearby attractions. Default location is used when GPS is not available.")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var defaultLocation: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.defaultLatitude = 40.0
        intent.defaultLongitude = 15.0
        return intent
    }
}

#Preview(as: .systemSmall) {
    CityGuideWidget()
} timeline: {
    LocationEntry(date: .now, configuration: .defaultLocation, coordinates: .init(latitude: 46.6, longitude: 17.7), locationName: "Brno")
    LocationEntry(date: .now, configuration: .defaultLocation, coordinates: .init(latitude: 43.6, longitude: 15.7), locationName: "Prague")
}
