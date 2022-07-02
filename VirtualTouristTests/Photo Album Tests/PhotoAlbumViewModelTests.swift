import XCTest
@testable import VirtualTourist

class PhotoAlbumViewModelTests: XCTestCase {

    var viewModel: PhotoAlbumViewModel!

    override func setUpWithError() throws {

        let mockCoreDataManager = CoreDataManager(context: TestCoreDataStack.context)

        viewModel = PhotoAlbumViewModel(photoAlbum: Album(),
                                        service: MockRepository(),
                                        database: mockCoreDataManager,
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
