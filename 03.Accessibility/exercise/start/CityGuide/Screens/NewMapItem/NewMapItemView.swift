//
//  NewMapItemView.swift
//  CityGuide
//
//  Created by David Prochazka on 21.04.2026.
//

import SwiftUI
import PhotosUI
import CoreLocation

struct NewMapItemView: View {
    @State private var viewModel: NewMapItemViewModel

    init(viewModel: NewMapItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Form {
            Section(content: {
                TextField("Insert location name", text: $viewModel.state.locationName)
            }, header: {
                Text("Location name")
            }, footer: {
                HStack {
                    Text("Latitude: \(viewModel.state.locationCoordinates.latitude)")
                    Spacer()
                    Text("Longitude: \(viewModel.state.locationCoordinates.longitude)")
                }
            })
            
            Section("Details") {
                Picker("Architectural style", selection: $viewModel.state.locationStyle) {
                    ForEach(ArchitecturalStyle.allCases) { option in
                        Text(option.name).tag(option)
                    }
                }
                .pickerStyle(.automatic)
                
                Picker("Location type", selection: $viewModel.state.locationType) {
                    ForEach(LocationType.allCases) { option in
                        Text(option.symbol).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Image") {
                Image(uiImage: viewModel.state.locationImage)
                    .resizable()
                    .scaledToFit()
                
                PhotosPicker("Select image", selection: $viewModel.state.pickedItem, matching: .images)
                    .onChange(of: viewModel.state.pickedItem) {
                        Task {
                            if let data = try? await viewModel.state.pickedItem?.loadTransferable(type: Data.self) {
                                if let image = UIImage(data: data) {
                                    viewModel.state.locationImage = image
                                }
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NewMapItemView(
        viewModel: NewMapItemViewModel()
    )
}
