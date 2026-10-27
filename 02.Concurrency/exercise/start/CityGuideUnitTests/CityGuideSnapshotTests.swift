//
//  CityGuideSnapshotTests.swift
//  CityGuide
//
//  Created by Martina Stremenova on 20.10.2026.
//

import SnapshotTesting
import XCTest
@testable import CityGuide
internal import SwiftUI

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

    @MainActor
    func testDetailViewDarkMode() {
        let view = DetailView(
            viewModel: DetailViewModel(
                mapItem: .getSample(),
                connector: Connector(),
                apiManager: APIManagerMock(returnValue: .failure(APIError.noResponse))
            )
        )

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13), traits: .init(userInterfaceStyle: .dark))
        )
    }

    @MainActor
    func testNewMapItemView() {
        let view = NavigationStack {
            NewMapItemView(viewModel: NewMapItemViewModel())
                .navigationTitle("New Location")
        }

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}

