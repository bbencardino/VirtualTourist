import XCTest
@testable import VirtualTourist

class CoreDataManagerTests: XCTestCase {

    var sut: CoreDataManager!

    override func setUpWithError() throws {
        sut = CoreDataManager(context: TestCoreDataStack().context)
    }

    override func tearDownWithError() throws {

    }

    func testCreatePinInDatabase() throws {

        // WHEN
        sut.createPin(latitude: -23.003, longitude: -3.003)

        // THEN
        XCTAssertEqual(sut.pins?.count, 1)
        let album = try XCTUnwrap(sut.pins?.first?.album)
        XCTAssertEqual(album.status,
                       PhotoAlbumStatus.notStarted.rawValue)
    }

    func testCreateImage() throws {
        // GIVEN
        let album = try makeAlbum()

        // WHEN
        sut.createImage(for: album, blob: Data(), url: "https://", id: 34)

        // THEN
        XCTAssert(album.images?.count == 1)
    }

    func testChangeAlbumStatus() throws {
        // GIVEN
        let album = try makeAlbum()

        // WHEN
        sut.changeStatus(of: album, to: .downloading)

        // THEN
        XCTAssertEqual(album.status, PhotoAlbumStatus.downloading.rawValue)
    }

    func testGetImage() {
        // GIVEN

        // WHEN

        // THEN
    }
//    func testDeleteImage() throws {
//
//        let blob: Data = Data
//        // GIVEN
//        let album = try makeAlbum()
//        sut.createImage(for: album, blob: Data(), url: "url", id: 34)
//        let image = album.images?.first
//
//        // WHEN
//        sut.deleteImage(image)
//
//        // THEN
//        XCTAssertTrue(sut.images?.count == 0)
//    }
}

// MARK: - helper methods
extension CoreDataManagerTests {

    private func makeAlbum() throws -> Album {
        sut.createPin(latitude: -23.003, longitude: -3.003)
        let album = try XCTUnwrap(sut.pins?.first?.album)

        return album
    }
}
