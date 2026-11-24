import Foundation

final class PhotoDetailViewModel {
    private let photo: UnsplashPhoto
    
    init(photo: UnsplashPhoto) {
        self.photo = photo
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
