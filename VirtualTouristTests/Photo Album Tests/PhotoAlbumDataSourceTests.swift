import XCTest
@testable import VirtualTourist

class PhotoAlbumDataSourceTests: XCTestCase {

    // 1. create a mock repository 
    // 2. Get the view Model and data source

    let collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: type(of: UICollectionViewLayout()).init())

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumbersOfItems_is20() {
        // GIVEN
        let viewModel = PhotoAlbumViewModel()
        let dataSource = PhotoAlbumDataSource(viewModel: viewModel)

        // WHEN
        let itensInRow = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)

        // THEN
        XCTAssertEqual(itensInRow, 20) //hard code tho
    }
}
