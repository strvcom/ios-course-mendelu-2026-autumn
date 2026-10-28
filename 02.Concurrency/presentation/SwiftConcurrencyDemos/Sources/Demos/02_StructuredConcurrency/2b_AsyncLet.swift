import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 2b · async let
// `downloadImage(_:)` lives in DownloadImage.swift in this folder.

#Playground("2b · async let") {
    try await measure("3 downloads with async let") {
        async let first = downloadImage(1) // starts immediately as a child task
        async let second = downloadImage(2)
        async let third = downloadImage(3)
        let images = try await [first, second, third] // wait for all three
    }
}
