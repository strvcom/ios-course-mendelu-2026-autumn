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
        
        let initialTemperature = await sut.state.temperature
        XCTAssertEqual(initialTemperature, "100")
        
        await sut.fetchWeatherData()
        
        let finalTemperature = await sut.state.temperature
        XCTAssertEqual(finalTemperature, "22°C")
    }
    
    func testFirstTemperatureIsUsed() async {
        let weatherData = WeatherData(daily: .init(time: [], maxTemperatures: [18.0, 25.0]))
        let sut = await createSUT(returnValue: .success(weatherData))

        await sut.fetchWeatherData()
        
        let fetchedTemperature = await sut.state.temperature
        XCTAssertEqual(fetchedTemperature, "18°C")
    }
    
    func testWeatherFethingThrowsError() async {
        let sut = await createSUT(returnValue: .failure(APIError.noResponse))
        
        await sut.fetchWeatherData()
        
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
