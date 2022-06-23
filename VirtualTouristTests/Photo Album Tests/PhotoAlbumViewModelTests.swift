import XCTest
@testable import VirtualTourist

class PhotoAlbumViewModelTests: XCTestCase {

    var viewModel: PhotoAlbumViewModel!

    override func setUpWithError() throws {
        // change database
        viewModel = PhotoAlbumViewModel(photoAlbum: Album(),
            service: MockRepository(),
                                        database: CoreData(),
                                        latitude: -23.000372,
                                        longitude: -43.365894)
        viewModel.getPhotosFromFlickr {}
    }

    override func tearDownWithError() throws {}

    func testNumberOfItems_is4() {
        // WHEN
        let numberOfItems = viewModel.numberOfItems()

        // THEN
        XCTAssertEqual(numberOfItems, 4)
    }
}
