//
//  PlaceDetailView.swift
//  CityGuide Watch App
//
//  Created by David Procházka on 06.10.2026.
//

import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: MapItem

    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: place.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Text(place.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text("\(place.type.symbol) \(place.style.name)")
                    .foregroundStyle(.secondary)
                Button("Navigate", systemImage: "figure.walk") {
                    navigate()
                }
            }
        }
    }

    // Opens Maps with walking directions to the place.
    private func navigate() {
        let location = CLLocation(latitude: place.coordinate.latitude,
                                  longitude: place.coordinate.longitude)
        let destination = MKMapItem(location: location, address: nil)
        destination.name = place.title
        destination.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ])
    }
}

#Preview {
    NavigationStack {
        PlaceDetailView(place: MapItem.getSample())
    }
}
