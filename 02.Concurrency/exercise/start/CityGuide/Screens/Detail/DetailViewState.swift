import SwiftUI

@Observable
class DetailViewState {
    var mapItem: MapItem
    var temperature: String = "100"

    init(mapItem: MapItem) {
        self.mapItem = mapItem
    }
}
