//
//  ListView.swift
//  CityGuide
//
//  Created by David Prochazka on 19.04.2026.
//

import SwiftUI
import CoreLocation

struct ListView: View {
    @State private var viewModel: MapViewModel
    @State private var isNewMapItemViewPresented: Bool = false

    private let connector: Connector

    init(viewModel: MapViewModel, connector: Connector) {
        self.viewModel = viewModel
        self.connector = connector
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.state.mapItems) { item in
                NavigationLink {
                    DetailView(viewModel: DetailViewModel(mapItem: item, connector: connector))
                        .navigationTitle(item.title)
                } label: {
                    Text(item.title)
                }
            }
            .sheet(isPresented: $isNewMapItemViewPresented) {
                showNewMapItemView()
            }
            .navigationTitle(Text("List"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New Place", systemImage: "add") {
                        isNewMapItemViewPresented.toggle()
                    }
                }
            }
        }
    }
    
    func showNewMapItemView() -> some View {
        let newMapItemViewModel = NewMapItemViewModel()
        
        return NavigationStack {
            NewMapItemView(
                viewModel: newMapItemViewModel
            )
            .navigationTitle("New Location")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isNewMapItemViewPresented.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        newMapItemViewModel.addMapItem()
                        isNewMapItemViewPresented.toggle()
                        viewModel.fetchMapItems() // update of the list
                    }
                }
            }
        }
    }
}

#Preview {
    ListView(viewModel: MapViewModel(), connector: Connector())
}
