//
//  CityGuideApp.swift
//  CityGuide
//
//  Created by David Procházka on 01.04.2026.
//

import SwiftUI

@main
struct CityGuideApp: App {
    @State private var connector = Connector()     // once, at app start

    var body: some Scene {
        WindowGroup {
            ContentView(connector: connector)
        }
    }
}
