import Foundation
@testable import GalleryApp

extension UnsplashPhoto {
    static func stub(
        id: String = "1",
        description: String? = "Description",
        altDescription: String? = "Alt description",
        likes: Int = 5,
        author: String = "Author"
    ) -> UnsplashPhoto {
        UnsplashPhoto(
            id: id,
            description: description,
            altDescription: altDescription,
            likes: likes,
            urls: URLs(
                regular: "https://example.com/regular.jpg",
                small: "https://example.com/small.jpg",
                thumb: "https://example.com/thumb.jpg"
            ),
            user: User(name: author)
        )
    }
}
