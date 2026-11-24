import XCTest
@testable import GalleryApp

final class FavoritesServiceTests: XCTestCase {
    private static let stack = CoreDataStack(inMemory: true)

    private var service: FavoritesService!

    override func setUp() {
        super.setUp()
        service = FavoritesService(stack: Self.stack)
        for id in service.fetchAll().compactMap(\.id) {
            service.remove(id: id)
        }
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func testAddMakesPhotoFavorite() {
        service.add(.stub(id: "a"))

        XCTAssertTrue(service.isFavorite(id: "a"))
    }

    func testRemoveDeletesFavorite() {
        service.add(.stub(id: "a"))
        service.remove(id: "a")

        XCTAssertFalse(service.isFavorite(id: "a"))
    }

    func testAddingSamePhotoTwiceKeepsOneRecord() {
        service.add(.stub(id: "a"))
        service.add(.stub(id: "a"))

        XCTAssertEqual(service.fetchAll().count, 1)
    }

    func testFetchAllReturnsNewestFirst() {
        service.add(.stub(id: "first"))
        service.add(.stub(id: "second"))

        XCTAssertEqual(service.fetchAll().compactMap(\.id), ["second", "first"])
    }
}
