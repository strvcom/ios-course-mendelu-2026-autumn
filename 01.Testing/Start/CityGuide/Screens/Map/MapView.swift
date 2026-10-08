//
//  MapView.swift
//  CityGuide
//
//  Created by David Procházka on 01.04.2026.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var viewModel: MapViewModel
    @State private var isDetailPresented: Bool = false
    
    private let connector: Connector

    init(viewModel: MapViewModel, connector: Connector) {
        self.viewModel = viewModel
        self.connector = connector
    }
    
    var body: some View {
        Map(position: $viewModel.state.cameraPosition) {
            ForEach(viewModel.state.mapItems) { item in
                Annotation("", coordinate: item.coordinate) {
                    VStack {
                        ZStack(alignment: .center) {
                            Circle()
                                .stroke(Color.cyan, lineWidth: 2.0)
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 35, height: 35)
                            Text(item.type.symbol)
                        }
                        Text(item.title)
                            .font(.callout)
                        Text(item.style.name)
                            .font(.caption)
                        
                    }
                    .onTapGesture {
                        viewModel.state.selectedMapItem = item
                        isDetailPresented.toggle()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchMapItems()
        }
        .task { // reloading of the user location each 2 seconds
            while !true {
                viewModel.fetchUserLocation()
                try? await Task.sleep(for: .seconds(2))
            }
        }
        .sheet(isPresented: $isDetailPresented) {
            if let selectedItem = viewModel.state.selectedMapItem {
                showMapItem(selectedItem)
            }
        }
    }
    
    private func showMapItem(_ selectedItem: MapItem) -> some View {
        return NavigationStack {
            DetailView(viewModel: DetailViewModel(mapItem: selectedItem, connector: connector))
                .navigationTitle(selectedItem.title)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") {
                            isDetailPresented.toggle()
                        }
                    }
                }
        }
        .presentationDetents([.fraction(0.3), .medium, .large])
        .presentationBackground(Color(.systemBackground)) // constant transparency of the background
    }
}

#Preview {
    MapView(viewModel: MapViewModel(), connector: Connector())
}
