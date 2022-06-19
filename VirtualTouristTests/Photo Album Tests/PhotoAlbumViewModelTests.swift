import XCTest
@testable import VirtualTourist

class PhotoAlbumViewModelTests: XCTestCase {

    var viewModel: PhotoAlbumViewModel!

    override func setUpWithError() throws {
        // change database
        viewModel = PhotoAlbumViewModel(service: MockRepository(),
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

    func testDownloadImages_success() {
        let path = "https://live.staticflickr.com/1232/1234_1234.jpg"
        // WHEN
        viewModel.downloadImage(path: path) { result in
            // THEN
            switch result {
            case .success(let data):
                let imageName = String(data: data, encoding: .utf8)
                XCTAssertEqual(imageName, "https://live.staticflickr.com/1232/1234_1234.jpg")
            default:
                XCTFail("should be success")
            }
        }
    }
}
