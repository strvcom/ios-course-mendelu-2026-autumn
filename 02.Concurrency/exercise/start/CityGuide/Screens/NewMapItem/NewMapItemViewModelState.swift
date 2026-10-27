//
//  NewMapItemState.swift
//  CityGuide
//
//  Created by David Prochazka on 21.04.2026.
//
import CoreLocation
import SwiftUI
import PhotosUI

@Observable
class NewMapItemViewModelState {
    var locationCoordinates: CLLocationCoordinate2D = .init(latitude: 49.2068018498442, longitude: 16.608120972760936)
    var locationName: String = ""
    var locationStyle: ArchitecturalStyle = .artDeco
    var locationImage: UIImage = UIImage(named: "meditation") ?? UIImage()
    var locationType: LocationType = .church
    
    var pickedItem: PhotosPickerItem?
}
