//
//  CityGuideUITests.swift
//  CityGuideUITests
//
//  Created by Martina Stremenova on 20.10.2026.
//

import XCTest

final class CityGuideUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        
        app = nil
    }

    @MainActor
    func testMapViewIsLoaded() {
        // App launched in setup
        // Next test if mapview visible
        XCTAssertTrue(app.otherElements["mapViewMap"].exists)
    }
    
    @MainActor
    func testNewPlaceViewIsOpened() {
        app.buttons["tabListButton"].tap()
        app.buttons["listNewPlaceButton"].tap()
        
        XCTAssertTrue(app.collectionViews["newPlaceForm"].exists)
    }

}
