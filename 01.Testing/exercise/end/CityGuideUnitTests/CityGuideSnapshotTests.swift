//
//  CityGuideSnapshotTests.swift
//  CityGuide
//
//  Created by Martina Stremenova on 20.10.2026.
//

import SnapshotTesting
import XCTest
@testable import CityGuide

final class CityGuideSnapshotTests: XCTestCase {
    
    @MainActor
    func testDetailView() {
        let view = DetailView(
            viewModel: DetailViewModel(
                mapItem: .getSample(),
                connector: Connector(),
                apiManager: APIManagerMock(returnValue: .failure(APIError.noResponse))
            )
        )

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}

