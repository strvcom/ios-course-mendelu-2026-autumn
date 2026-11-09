//
//  AppIntent.swift
//  CityGuideWidget
//
//  Created by David Procházka on 12.05.2026.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an CityGuide widget." }
  
    @Parameter(title: "Default latitude", default: 46.6)
    var defaultLatitude: Double
    
    @Parameter(title: "Default longitude", default: 16.6)
    var defaultLongitude: Double
}
