//
//  CoreLocationManager.swift
//  CityGuide
//
//  Created by David Procházka on 15.04.2026.
//
import CoreLocation

class CoreLocationManager: NSObject, LocationManaging, CLLocationManagerDelegate {
   
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocationCoordinate2D? = nil
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            self.currentLocation = currentLocation.coordinate
        }
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return currentLocation
    }
    
    // TODO
    func getCurrentLocationName() -> String? {
        return "Brno"
    }
}
