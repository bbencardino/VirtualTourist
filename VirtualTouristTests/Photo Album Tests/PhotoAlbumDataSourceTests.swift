import XCTest
@testable import VirtualTourist

class PhotoAlbumDataSourceTests: XCTestCase {

    var viewModel: PhotoAlbumViewModel!
    var dataSource: PhotoAlbumDataSource!
    var collectionView: UICollectionView!

    override func setUpWithError() throws {
        viewModel = PhotoAlbumViewModel(service: MockRepository(),
                                        latitude: -23.000372,
                                        longitude: -43.365894)
        dataSource = PhotoAlbumDataSource(viewModel: viewModel)
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: type(of: UICollectionViewLayout()).init())
    }

    override func tearDownWithError() throws {}

    func testNumbersOfItems() {
        // WHEN
        let itensInRow = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)

        // THEN
        XCTAssertEqual(itensInRow, viewModel.numberOfItems())
    }
}
