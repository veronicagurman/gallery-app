import Foundation

protocol PhotoServiceProtocol {
    func fetchPhotos(page: Int, perPage: Int) async throws -> [UnsplashPhoto]
}

final class PhotoService: PhotoServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    func fetchPhotos(page: Int, perPage: Int) async throws -> [UnsplashPhoto] {
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        guard let url = components?.url else {throw NetworkError.invalidURL  }
        
        var request = URLRequest(url: url)
                request.setValue("Client-ID \(Config.unsplashAccessKey)", forHTTPHeaderField: "Authorization")

                let data: Data
                let response: URLResponse
                do {
                    (data, response) = try await session.data(for: request)
                } catch {
                    throw NetworkError.transport(error)
                }

                if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                    throw NetworkError.badStatus(http.statusCode)
                }

                do {
                    return try decoder.decode([UnsplashPhoto].self, from: data)
                } catch {
                    throw NetworkError.decoding(error)
                }
        }
}
