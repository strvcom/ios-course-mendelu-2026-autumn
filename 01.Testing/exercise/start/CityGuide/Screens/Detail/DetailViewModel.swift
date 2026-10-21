import SwiftUI
import CoreLocation
import FoundationModels

@Observable
final class DetailViewModel {
    var state: DetailViewState
    private var apiManager: APIManaging
    private let connector: Connector
    private var tipTask: Task<Void, Never>?

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

    func generateTip() {
        tipTask = Task { @MainActor in // main thread
            // on-device model needs Apple Intelligence turned on
            guard SystemLanguageModel.default.isAvailable else {
                state.tip = "Apple Intelligence is not available on this device."
                return
            }

            state.isGeneratingTip = true
            defer { state.isGeneratingTip = false }

            // instructions say how the model should behave
            let session = LanguageModelSession(
                instructions: "You are a friendly city guide in Brno. Answer in 2–3 short sentences."
            )

            // prompt is built from data we already have on the screen
            let mapItem = state.mapItem
            let prompt = """
            Place: \(mapItem.title). Architectural style: \(mapItem.style.name). \
            Type: \(mapItem.type). Today's max temperature: \(state.temperature).
            Give a visitor one thing to notice about this style and what to wear.
            """

            do {
                let stream = session.streamResponse(to: prompt)

                // every snapshot contains the whole text generated so far
                for try await snapshot in stream {
                    state.tip = snapshot.content
                }
            } catch {
                print("❌ \(error)")
            }
        }
    }

    func cancelTip() {
        tipTask?.cancel()
    }
}
