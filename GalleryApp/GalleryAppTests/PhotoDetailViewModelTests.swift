import XCTest
@testable import GalleryApp

private final class FavoritesServiceMock: FavoritesServiceProtocol {
    var storedIDs: Set<String> = []

    func isFavorite(id: String) -> Bool {
        storedIDs.contains(id)
    }

    func add(_ photo: UnsplashPhoto) {
        storedIDs.insert(photo.id)
    }

    func remove(id: String) {
        storedIDs.remove(id)
    }

    func fetchAll() -> [FavoritePhoto] {
        []
    }
}

final class PhotoDetailViewModelTests: XCTestCase {
    func testDescriptionPrefersDescription() {
        let viewModel = PhotoDetailViewModel(
            photo: .stub(description: "Main", altDescription: "Alt"),
            favoritesService: FavoritesServiceMock()
        )

        XCTAssertEqual(viewModel.descriptionText, "Main")
    }

    func testDescriptionFallsBackToAltDescription() {
        let viewModel = PhotoDetailViewModel(
            photo: .stub(description: nil, altDescription: "Alt"),
            favoritesService: FavoritesServiceMock()
        )

        XCTAssertEqual(viewModel.descriptionText, "Alt")
    }

    func testDescriptionFallsBackToPlaceholder() {
        let viewModel = PhotoDetailViewModel(
            photo: .stub(description: nil, altDescription: nil),
            favoritesService: FavoritesServiceMock()
        )

        XCTAssertEqual(viewModel.descriptionText, "No description")
    }

    func testLikesText() {
        let viewModel = PhotoDetailViewModel(
            photo: .stub(likes: 42),
            favoritesService: FavoritesServiceMock()
        )

        XCTAssertEqual(viewModel.likesText, "42 likes")
    }

    func testToggleFavoriteAddsThenRemoves() {
        let viewModel = PhotoDetailViewModel(
            photo: .stub(id: "x"),
            favoritesService: FavoritesServiceMock()
        )
        var states: [Bool] = []
        viewModel.onFavoriteChange = { states.append($0) }

        viewModel.toggleFavorite()
        viewModel.toggleFavorite()

        XCTAssertEqual(states, [true, false])
    }
}
