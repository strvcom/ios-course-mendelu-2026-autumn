//
//  TimelineEntry.swift
//  CityGuide
//
//  Created by David Procházka on 12.05.2026.
//
import WidgetKit
import CoreLocation

struct LocationEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let coordinates: CLLocationCoordinate2D?
    let locationName: String?
}
