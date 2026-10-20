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
        
        // Throw-away destination, so we have temporary in-memory database
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
    
}

private extension MapViewModelTests {
    func createSUT() -> MapViewModel {
        return MapViewModel(
            dataManager: dataManager,
            locationManager: MockLocationManager()
        )
    }
}
