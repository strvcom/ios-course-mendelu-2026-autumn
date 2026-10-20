//
//  MapViewModelSwiftTests.swift
//  CityGuide
//
//  Created by Martina Stremenova on 20.10.2026.
//

import CoreData
import Testing
@testable import CityGuide
internal import MapKit
internal import SwiftUI

//@Suite(.serialized)
final class MapViewModelSwiftTests {
    private var dataManager: DataManaging!
    
    init() {
        let persistentContainer = NSPersistentContainer(name: "CityGuide")
        
        // Throw-away destination, so we have temporary in-memory database
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.persistentStoreDescriptions = [description]
        
        dataManager = CoreDataManager(container: persistentContainer)
        
        print("🍏 - init")
    }
    
    deinit {
        dataManager = nil
        print("🍏 - deinit")
    }
    
    @Test
    func databaseIsEmpty() {
        let sut = createSUT()
        sut.fetchMapItems()
        
        #expect(sut.state.mapItems.isEmpty)
        #expect(sut.state.selectedMapItem == nil)
        print("🍏 - Test 1")
    }
    
    @Test
    func databaseHasData() {
        dataManager.savePlace(MapItem.getSample())
        
        let sut = createSUT()
        sut.fetchMapItems()
        
        #expect(!sut.state.mapItems.isEmpty)
        #expect(sut.state.mapItems.count == 1)
        
        print("🍏 - Test 2")
    }
    
    @Test
    func locationIsSynchronized() {
        let sut = createSUT()
        
        #expect(sut.state.cameraPosition.camera != nil)
        #expect(sut.state.cameraPosition.camera?.centerCoordinate.latitude == 49.209)
        #expect(sut.state.cameraPosition.camera?.centerCoordinate.longitude == 16.614)
        
        sut.fetchUserLocation()
        
        #expect(sut.state.cameraPosition.camera != nil)
        #expect(sut.state.cameraPosition.camera?.centerCoordinate.latitude == 59.2)
        #expect(sut.state.cameraPosition.camera?.centerCoordinate.longitude == 16.7)
    }
}

private extension MapViewModelSwiftTests {
    func createSUT() -> MapViewModel {
        return MapViewModel(
            dataManager: dataManager,
            locationManager: MockLocationManager()
        )
    }
}
