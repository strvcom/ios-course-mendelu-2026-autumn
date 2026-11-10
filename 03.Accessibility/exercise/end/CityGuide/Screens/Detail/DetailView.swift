//
//  DetailView.swift
//  CityGuide
//
//  Created by David Procházka on 01.04.2026.
//

import SwiftUI

struct DetailView: View {
    @State private var viewModel: DetailViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                Text(viewModel.state.mapItem.title)
            }
            
            Section(header: Text("Location information")) {
                Text(viewModel.state.mapItem.style.name)
                Text(viewModel.state.mapItem.type.symbol)
                    .accessibilityLabel(viewModel.state.mapItem.type.accessibilityName)
            }
            
            Section(header: Text("Photo")) {
                Image(uiImage: viewModel.state.mapItem.image)
                    .resizable()
                    .scaledToFill()
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .accessibilityLabel("Photo of \(viewModel.state.mapItem.title)")
                    .accessibilityIgnoresInvertColors()
            }

            Section(header: Text("Temperature")) {
                Text(viewModel.state.temperature)
            }

            Section(header: Text("Visitor tip")) {
                if !viewModel.state.tip.isEmpty {
                    Text(viewModel.state.tip)
                }

                Button("Get tip", systemImage: "sparkles") {
                    viewModel.generateTip()
                }
                .symbolEffect(
                    .rotate,
                    isActive: viewModel.state.isGeneratingTip && !reduceMotion
                )
                .disabled(viewModel.state.isGeneratingTip)
            }
        }
        // when view appears, fetch weather for temperature
        .onAppear(
            perform: {
                viewModel.fetchWeatherData()
            })
        // stop generating the tip when user leaves the screen
        .onDisappear(
            perform: {
                viewModel.cancelTip()
            })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Send to Watch", systemImage: "applewatch") {
                    viewModel.sendToWatch()
                }
            }
        }
    }
}

#Preview {
    DetailView(viewModel: DetailViewModel(mapItem: MapItem.getSample(), connector: Connector()))
}
