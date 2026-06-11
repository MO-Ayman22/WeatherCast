import CoreData
import Foundation

public struct PersistenceController {
    public static let shared = PersistenceController()

    public static var preview: PersistenceController = PersistenceController(inMemory: true)

    public let container: NSPersistentContainer

    public init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WeatherCast")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
