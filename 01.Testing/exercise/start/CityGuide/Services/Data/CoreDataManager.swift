import SwiftUI
import CoreData
import MapKit

final class CoreDataManager: DataManaging {

    private let container = NSPersistentContainer(name: "CityGuide") // beware of typos!
    private var context: NSManagedObjectContext { container.viewContext }

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to create container: \(error.localizedDescription)")
            }
        }
    }

    func savePlace(_ item: MapItem) {
        let request = NSFetchRequest<MapItemEntity>(entityName: "MapItemEntity")
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)

        do {
            let results = try context.fetch(request)
            let entity = results.first ?? MapItemEntity(context: context) // if none is found, create one
            entity.id = item.id
            entity.latitude = item.coordinate.latitude
            entity.longitude = item.coordinate.longitude
            entity.title = item.title
            entity.style = item.style.rawValue
            entity.type = item.type.rawValue
            entity.imageData = item.image.pngData()
            save()
        } catch {
            print("CoreDataManager savePlace error: \(error.localizedDescription)")
        }
    }

    func fetchPlaces() -> [MapItem] {
        let request = NSFetchRequest<MapItemEntity>(entityName: "MapItemEntity")
        
        do {
            let entities = try context.fetch(request)
            
            return entities.map{ entity in
                return MapItem(
                    id: entity.id ?? UUID(),
                    coordinate: CLLocationCoordinate2D(latitude: entity.latitude, longitude: entity.longitude),
                    title: entity.title ?? "No title",
                    style: ArchitecturalStyle(rawValue: entity.style) ?? .artDeco,
                    type: LocationType(rawValue: entity.type) ?? .publicBuilding,
                    image: UIImage(data: entity.imageData ?? Data()) ?? UIImage())
            }
        } catch {
            print("CoreDataManager fetchPlaces error: \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: Private methods
private extension CoreDataManager {

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }
}
