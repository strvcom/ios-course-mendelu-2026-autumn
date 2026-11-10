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
    @ScaledMetric private var pinSize: CGFloat = 35
    
    private let connector: Connector

    init(viewModel: MapViewModel, connector: Connector) {
        self.viewModel = viewModel
        self.connector = connector
    }
    
    var body: some View {
        Map(position: $viewModel.state.cameraPosition) {
            ForEach(viewModel.state.mapItems) { item in
                Annotation("", coordinate: item.coordinate) {
                    Button {
                        viewModel.state.selectedMapItem = item
                        isDetailPresented.toggle()
                    } label: {
                        VStack {
                            ZStack(alignment: .center) {
                                Circle()
                                    .stroke(Color.blue, lineWidth: 4.0)
                                    .fill(Color(.systemBackground).opacity(0.8))
                                    .frame(width: pinSize, height: pinSize)
                                Text(item.type.symbol)
                            }
                            VStack {
                                Text(item.title)
                                    .font(.callout)
                                Text(item.style.name)
                                    .font(.caption)
                            }
                            .fixedSize()
                            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(item.title), \(item.style.name), \(item.type.accessibilityName)")
                }
                
            }
        }
        .accessibilityIdentifier("mapViewMap")
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

#Preview {
    MapView(viewModel: MapViewModel(), connector: Connector())
        .colorScheme(.dark)
        .dynamicTypeSize(.accessibility5)
}
