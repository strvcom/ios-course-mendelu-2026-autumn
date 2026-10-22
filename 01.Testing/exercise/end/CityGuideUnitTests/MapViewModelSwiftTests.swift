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

@Suite(.serialized)
final class MapViewModelSwiftTests {
    private var dataManager: DataManaging!
    
    init() {
        let persistentContainer = NSPersistentContainer(name: "CityGuide")

        // Throw-away database for tests:
        // By default the container stores data in a SQLite file in the app's sandbox,
        // so tests would read and change the same data as the app itself.
        // Pointing the store URL to /dev/null keeps the SQLite store type,
        // but nothing is ever written to disk - the data lives only in memory.
        // Every test creates its own container, so it starts with an empty database
        // and nothing leaks into the next test or into the real app data.
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.persistentStoreDescriptions = [description]

        dataManager = CoreDataManager(container: persistentContainer)
    }
    
    deinit {
        dataManager = nil
    }
    
    @Test
    func databaseIsEmpty() {
        let sut = createSUT()
        sut.fetchMapItems()
        
        #expect(sut.state.mapItems.isEmpty)
        #expect(sut.state.selectedMapItem == nil)
    }
    
    @Test
    func locationIsSynchronized() {
        let sut = createSUT()
        
        #expect(sut.state.cameraPosition.camera != nil)
        #expect(sut.state.cameraPosition.camera?.centerCoordinate.latitude == 49.209)
        #expect(sut.state.cameraPosition.camera?.centerCoordinate.longitude == 16.614)
        
        sut.fetchUserLocation()
        
        #expect(sut.state.cameraPosition.camera != nil)
        #expect(sut.state.cameraPosition.camera?.centerCoordinate.latitude == 49.2)
        #expect(sut.state.cameraPosition.camera?.centerCoordinate.longitude == 16.7)
    }

    @Test("Style is stored", arguments: ArchitecturalStyle.allCases)
    func styleIsStored(_ style: ArchitecturalStyle) throws {
        var item = MapItem.getSample()
        item.style = style
        dataManager.savePlace(item)

        let sut = createSUT()
        sut.fetchMapItems()

        let fetched = try #require(sut.state.mapItems.first)
        #expect(fetched.style == style)
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
