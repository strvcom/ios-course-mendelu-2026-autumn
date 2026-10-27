import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 2a · Sequential
// `downloadImage(_:)` lives in DownloadImage.swift in this folder.

#Playground("2a · Sequential") {
    try await measure("3 downloads, one after another") {
        let first = try await downloadImage(1)
        let second = try await downloadImage(2)
        let third = try await downloadImage(3)
    }
}
