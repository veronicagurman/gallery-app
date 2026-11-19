import Foundation

enum Config {
    static var unsplashAccessKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "UnsplashAccessKey") as? String,
              !key.isEmpty,
              key != "YOUR_ACCESS_KEY_HERE" else {
            fatalError("Unsplash access key is missing." +
                       "Copy Secrets.example.xcconfig to Secrets.xcconfig and set your key")
        }
        return key
    }
}
