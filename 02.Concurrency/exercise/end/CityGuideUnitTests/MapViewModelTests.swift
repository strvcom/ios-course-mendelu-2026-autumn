//
//  MapViewModelTests.swift
//  CityGuide
//
//  Created by Martina Stremenova on 20.10.2026.
//

import CoreData
import XCTest
@testable import CityGuide

final class MapViewModelTests: XCTestCase {
    private var dataManager: DataManaging!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
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
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        dataManager = nil
    }
    
    func testDatabaseIEmpty() {
        let sut = createSUT()
        sut.fetchMapItems()
        
        XCTAssertTrue(sut.state.mapItems.isEmpty)
    }
    
    func testDatabaseIsPopulated() {
        dataManager.savePlace(MapItem.getSample())
        
        let sut = createSUT()
        sut.fetchMapItems()
        
        XCTAssertFalse(sut.state.mapItems.isEmpty)
        XCTAssertTrue(sut.state.mapItems.count == 1)
    }

    func testSavingSameItemTwiceUpdatesIt() {
        var item = MapItem.getSample()
        dataManager.savePlace(item)
        item.title = "Renamed"
        dataManager.savePlace(item)

        let sut = createSUT()
        sut.fetchMapItems()

        XCTAssertEqual(sut.state.mapItems.count, 1)
        XCTAssertEqual(sut.state.mapItems.first?.title, "Renamed")
    }
}

private extension MapViewModelTests {
    func createSUT() -> MapViewModel {
        return MapViewModel(
            dataManager: dataManager,
            locationManager: MockLocationManager()
        )
    }
}
