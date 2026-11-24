import Foundation

final class FavoritesViewModel {
    private let service: FavoritesServiceProtocol

    private(set) var photos: [UnsplashPhoto] = []

    var onUpdate: (() -> Void)?

    init(service: FavoritesServiceProtocol = FavoritesService.shared) {
        self.service = service
    }

    func reload() {
        photos = service.fetchAll().compactMap { $0.asUnsplashPhoto }
        onUpdate?()
    }
}

extension FavoritePhoto {
    var asUnsplashPhoto: UnsplashPhoto? {
        guard let id, let authorName, let smallURL, let regularURL else { return nil }
        return UnsplashPhoto(
            id: id,
            description: photoDescription,
            altDescription: nil,
            likes: Int(likes),
            urls: UnsplashPhoto.URLs(regular: regularURL, small: smallURL, thumb: smallURL),
            user: UnsplashPhoto.User(name: authorName)
        )
    }
}
