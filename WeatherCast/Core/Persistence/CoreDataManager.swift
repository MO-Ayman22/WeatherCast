import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherCast")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed to load: \(error)")
            }
        }
        container.viewContext.undoManager = UndoManager()
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.undoManager = UndoManager()
        return context
    }

    func save(context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        try context.save()
    }

    func undo(context: NSManagedObjectContext) {
        context.undoManager?.undo()
    }
}
