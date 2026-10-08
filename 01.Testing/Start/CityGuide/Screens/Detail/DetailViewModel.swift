import SwiftUI
import CoreLocation

@Observable
final class DetailViewModel {
    var state: DetailViewState
    private var apiManager: APIManaging
    private let connector: Connector

    init(mapItem: MapItem, connector: Connector) {
        self.state = DetailViewState(mapItem: mapItem)
        self.connector = connector
        apiManager = DIContainer.shared.resolve()
    }

    func sendToWatch() {
        connector.send(state.mapItem)
    }

    func fetchWeatherData() {
        Task { @MainActor in // main thread
            do {
                // endpoint
                let endpoint = WeatherDataRouter.dailyMaxTemperature(
                    long: state.mapItem.coordinate.longitude,
                    lat: state.mapItem.coordinate.latitude
                )
                // fire request and get data
                let weatherData: WeatherData = try await apiManager.request(endpoint)

                // get temperature from data
                let temperature = weatherData.daily.maxTemperatures.first
                guard let temperature else {
                    return
                }

                // format temperature
                let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
                let measurementFormatter = MeasurementFormatter()
                let formatterTemperature = measurementFormatter.string(
                    from: measurement
                )

                // pass temperature to state
                state.temperature = formatterTemperature
            } catch {
                print("❌ \(error)")
            }
        }
    }
}
