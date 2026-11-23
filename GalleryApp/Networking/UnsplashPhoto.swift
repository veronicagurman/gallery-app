import Foundation

struct UnsplashPhoto: Decodable {
    let id: String
    let description: String?
    let altDescription: String?
    let likes: Int
    let urls: URLs
    let user: User

    struct URLs: Decodable {
        let regular: String
        let small: String
        let thumb: String
    }

    struct User: Decodable {
        let name: String
    }
}
