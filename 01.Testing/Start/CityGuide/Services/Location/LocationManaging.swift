//
//  LocationManaging.swift
//  CityGuide
//
//  Created by David Procházka on 15.04.2026.
//

import SwiftUI
import CoreLocation

protocol LocationManaging {
    func getCurrentLocation() -> CLLocationCoordinate2D?
    func getCurrentLocationName() -> String?
}
