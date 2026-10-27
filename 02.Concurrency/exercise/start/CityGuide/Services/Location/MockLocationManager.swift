//
//  MockLocationManager.swift
//  CityGuide
//
//  Created by David Procházka on 15.04.2026.
//
import CoreLocation

class MockLocationManager: LocationManaging {
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: 49.2, longitude: 16.7)
    }
    
    func getCurrentLocationName() -> String? {
        return "Brno"
    }

}
