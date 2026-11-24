import Foundation

final class PhotoDetailViewModel {
    private let photo: UnsplashPhoto
    private let favoritesService: FavoritesServiceProtocol

    var onFavoriteChange: ((Bool) -> Void)?

    init(
        photo: UnsplashPhoto,
        favoritesService: FavoritesServiceProtocol = FavoritesService.shared
    ) {
        self.photo = photo
        self.favoritesService = favoritesService
    }

    var isFavorite: Bool {
        favoritesService.isFavorite(id: photo.id)
    }

    func toggleFavorite() {
        if isFavorite {
            favoritesService.remove(id: photo.id)
        } else {
            favoritesService.add(photo)
        }
        onFavoriteChange?(isFavorite)
    }
    
    var imageURLString: String {
        photo.urls.regular
    }

    var placeholderURLString: String {
        photo.urls.small
    }
    
    var authorText: String {
        photo.user.name
    }
    
    var descriptionText: String {
        photo.description ?? photo.altDescription ?? "No description"
    }
    
    var likesText: String {
        "\(photo.likes) likes"
    }
}
