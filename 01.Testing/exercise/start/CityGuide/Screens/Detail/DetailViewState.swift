import SwiftUI

@Observable
class DetailViewState {
    var mapItem: MapItem
    var temperature: String = "100"
    var tip: String = ""
    var isGeneratingTip: Bool = false

    init(mapItem: MapItem) {
        self.mapItem = mapItem
    }
}
