//
//  ContentView.swift
//  CityGuide
//
//  Created by David Procházka on 01.04.2026.
//

import SwiftUI

struct ContentView: View {
    var viewModel = MapViewModel()
    let connector: Connector                // created and owned by the App

    var body: some View {
        TabView {
            Tab("Map", systemImage: "map") {
                MapView(viewModel: viewModel, connector: connector)
            }

            Tab("List", systemImage: "list.bullet") {
                ListView(viewModel: viewModel, connector: connector)
            }
        }
    }
}

#Preview {
    ContentView(connector: Connector())
}
