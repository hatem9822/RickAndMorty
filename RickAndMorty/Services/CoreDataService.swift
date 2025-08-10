import Foundation
import CoreData
import UIKit

final class CoreDataService {
    static let shared = CoreDataService()

    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext { container.viewContext }

    // MARK: - Init
    init(container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.container = container
        // Merge changes from background contexts if you add them later
        self.context.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Public API
    @discardableResult
    func addFavourite(id: Int32) throws -> FavouriteCharacters {
        if let existing = try fetchFavourite(by: id) {
            return existing
        }

        let favourite = FavouriteCharacters(context: context)
        favourite.setValue(id, forKey: "id")
        try saveContextIfNeeded()
        return favourite
    }

    func removeFavourite(id: Int32) throws {
        guard let favourite = try fetchFavourite(by: id) else { return }
        context.delete(favourite)
        try saveContextIfNeeded()
    }

    func isFavourite(id: Int32) throws -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteCharacters")
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        let count = try context.count(for: request)
        return count > 0
    }

    // Optional helpers
    func allFavourites() throws -> [FavouriteCharacters] {
        let request = NSFetchRequest<FavouriteCharacters>(entityName: "FavouriteCharacters")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return try context.fetch(request)
    }

    // MARK: - Private
    private func fetchFavourite(by id: Int32) throws -> FavouriteCharacters? {
        let request = NSFetchRequest<FavouriteCharacters>(entityName: "FavouriteCharacters")
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func saveContextIfNeeded() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}


