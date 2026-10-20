//
//  DetailViewModelTests.swift
//  CityGuide
//
//  Created by Martina Stremenova on 19.10.2026.
//

import XCTest
@testable import CityGuide

class DetailViewModelTests: XCTestCase {
    func testTemperatureLoadedSuccessfully() async {
        let weatherData = WeatherData(daily: .init(time: [], maxTemperatures: [22.0]))
        let sut = await createSUT(returnValue: .success(weatherData))
        
        // Setup expectation
        let expectation = XCTestExpectation(description: "Get right value of temperature")
        
        await sut.fetchWeatherData()
        
        Task { @MainActor in
            let _ = await waitUntil {
                sut.state.temperature == "22°C"
            }
            
            expectation.fulfill()
        }
        
        // Wait for expectation fulfillment with timeout
        await fulfillment(of: [expectation], timeout: 100.0)
    }
    
    func testWeatherFethingThrowsError() async {
        let sut = await createSUT(returnValue: .failure(APIError.noResponse))
        
        await sut.fetchWeatherData()
        
        // No new data -> no new temperature
        let temperature = await sut.state.temperature
        XCTAssertEqual(temperature, "100")
    }
}

private extension DetailViewModelTests {
    @MainActor
    func createSUT(returnValue: Result<Decodable, Error>) -> DetailViewModel {
        DetailViewModel(
            mapItem: .getSample(),
            connector: Connector(),
            apiManager: APIManagerMock(returnValue: returnValue)
        )
    }
}

func waitUntil(timeout: TimeInterval = 10, condition: () -> Bool) async -> Bool {
    let deadline = Date().addingTimeInterval(timeout)
    while Date() < deadline {
        if condition() {
            return true
        }
        try? await Task.sleep(for: .milliseconds(10))
    }
    return condition()
}

