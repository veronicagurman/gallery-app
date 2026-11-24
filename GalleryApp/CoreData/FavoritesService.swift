import CoreData

protocol FavoritesServiceProtocol {
    func isFavorite(id: String) -> Bool
    func add(_ photo: UnsplashPhoto)
    func remove(id: String)
    func fetchAll() -> [FavoritePhoto]
}

final class FavoritesService: FavoritesServiceProtocol {
    static let shared = FavoritesService()

    private let stack: CoreDataStack

    private var context: NSManagedObjectContext {
        stack.viewContext
    }

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }

    func isFavorite(id: String) -> Bool {
        let request = FavoritePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return ((try? context.count(for: request)) ?? 0) > 0
    }

    func add(_ photo: UnsplashPhoto) {
        guard !isFavorite(id: photo.id) else { return }

        let favorite = FavoritePhoto(context: context)
        favorite.id = photo.id
        favorite.authorName = photo.user.name
        favorite.photoDescription = photo.description ?? photo.altDescription
        favorite.likes = Int32(photo.likes)
        favorite.smallURL = photo.urls.small
        favorite.regularURL = photo.urls.regular
        favorite.addedAt = Date()
        stack.saveContext()
    }

    func remove(id: String) {
        let request = FavoritePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let items = try? context.fetch(request) else { return }
        for item in items {
            context.delete(item)
        }
        stack.saveContext()
    }

    func fetchAll() -> [FavoritePhoto] {
        let request = FavoritePhoto.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "addedAt", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
}
