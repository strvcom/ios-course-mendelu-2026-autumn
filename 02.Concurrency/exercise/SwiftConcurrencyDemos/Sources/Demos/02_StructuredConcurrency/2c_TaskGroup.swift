import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 2c · TaskGroup
// `downloadImage(_:)` lives in DownloadImage.swift in this folder.

#Playground("2c · TaskGroup") {
    try await measure("10 downloads in a TaskGroup") {
        let images = try await withThrowingTaskGroup { group in
            for id in 1...10 {
                group.addTask { try await downloadImage(id) }
            }

            var images: [String] = []
            for try await image in group { // results arrive in COMPLETION order
                images.append(image)
            }
            return images
        }
        print(images)
    }
}
