import Foundation

enum NetworkError: Error {
    case invalidURL
    case badStatus(Int)
    case decoding(Error)
    case transport(Error)
}
