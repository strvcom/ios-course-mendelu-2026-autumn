//
//  MapItem.swift
//  CityGuide
//
//  Created by David Procházka on 01.04.2026.
//
import SwiftUI
import MapKit

enum ArchitecturalStyle: Int16, CaseIterable, Identifiable {
    var id: Int16 { rawValue }
    
    case classicism = 1
    case gothic = 2
    case baroque = 3
    case bauhaus = 4
    case artDeco = 5
    
    var name: String {
        switch self {
        case .classicism:
            return "Classicism"
        case .gothic:
            return "Gothic"
        case .baroque:
            return "Baroque"
        case .bauhaus:
            return "Bauhaus"
        case .artDeco:
            return "Art Deco"
        }
    }
}

enum LocationType: Int16, CaseIterable, Identifiable {
    var id: Int16 { rawValue }
    
    case house = 1
    case publicBuilding = 2
    case industrial = 3
    case church = 4
    case historicalSite = 5
    
    var symbol: String {
        switch self {
        case .church:
            return "⛪️"
        case .house:
            return "🏠"
        case .industrial:
            return "🏭"
        case .historicalSite:
            return "🏛️"
        case .publicBuilding:
            return "🏢"
        }
    }
}

struct MapItem: Identifiable {
    var id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String
    var style: ArchitecturalStyle
    var type: LocationType
    var image: UIImage
    
    static func getSample() -> MapItem {
        .init(coordinate: .init(latitude: 49.20931500253389, longitude: 16.614563867331807),
              title: "Sample MENDELU",
              style: .baroque,
              type: .historicalSite,
              image: UIImage(named: "mendelu") ?? UIImage())
    }
}
