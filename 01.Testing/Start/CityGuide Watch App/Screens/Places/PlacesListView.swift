//
//  PlacesListView.swift
//  CityGuide Watch App
//
//  Created by David Procházka on 06.10.2026.
//

import SwiftUI

struct PlacesListView: View {
    let viewModel: PlacesViewModel          // created and owned by the App

    var body: some View {
        NavigationStack {
            List(viewModel.state.places) { place in
                NavigationLink {
                    PlaceDetailView(place: place)
                } label: {
                    Label(place.title, systemImage: "mappin.circle")
                }
            }
            .overlay {
                if viewModel.state.places.isEmpty {
                    ContentUnavailableView(
                        "No places yet",
                        systemImage: "map",
                        description: Text("Send a place from the detail in the iPhone app.")
                    )
                }
            }
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: viewModel.isPhoneReachable
                          ? "iphone.radiowaves.left.and.right"
                          : "iphone.slash")
                        .foregroundStyle(viewModel.isPhoneReachable ? .green : .secondary)
                }
            }
        }
        .onAppear {
            viewModel.fetchPlaces()
        }
    }
}

#Preview {
    PlacesListView(viewModel: PlacesViewModel(connector: Connector()))
}
