import Foundation

final class PhotoDetailViewModel {
    private let photo: UnsplashPhoto
    
    init(photo: UnsplashPhoto) {
        self.photo = photo
    }
    
    var imageURL: URL? {
        URL(string: photo.urls.regular)
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
