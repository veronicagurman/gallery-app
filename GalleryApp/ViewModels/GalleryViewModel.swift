import Foundation

final class GalleryViewModel {
    private let service: PhotoServiceProtocol
    private let perPage = 30
    private var currentPage = 1
    private var isLoading = false
    private var hasMore = true

    private(set) var photos: [UnsplashPhoto] = []

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    init(service: PhotoServiceProtocol = PhotoService()) {
        self.service = service
    }

    func loadNextPage() {
        guard !isLoading, hasMore else { return }
        isLoading = true

        Task {
            do {
                let newPhotos = try await service.fetchPhotos(page: currentPage, perPage: perPage)
                photos.append(contentsOf: newPhotos)
                currentPage += 1
                hasMore = newPhotos.count == perPage
                onUpdate?()
            } catch {
                onError?("Не удалось загрузить фотографии")
            }
            isLoading = false
        }
    }
}
