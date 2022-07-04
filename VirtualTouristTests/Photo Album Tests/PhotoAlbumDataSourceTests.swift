import XCTest
@testable import VirtualTourist

class PhotoAlbumDataSourceTests: XCTestCase {

    var viewModel: PhotoAlbumViewModel!
    var dataSource: PhotoAlbumDataSource!
    var collectionView: UICollectionView!

    override func setUpWithError() throws {
        let mockCoreDataManager = CoreDataManager(context: TestCoreDataStack().context)
        // swiftlint: disable force_try
        let album = try! MockDataFactory().makeAlbum()
        viewModel = PhotoAlbumViewModel(photoAlbum: album,
                                        service: MockRepository(),
                                        database: mockCoreDataManager,
                                        latitude: -23.000372,
                                        longitude: -43.365894)
        dataSource = PhotoAlbumDataSource(viewModel: viewModel)

        // Collection View setups
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: type(of: UICollectionViewLayout()).init())
        collectionView.register(PhotoAlbumCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.dataSource = dataSource
    }

    override func tearDownWithError() throws {}

    func testNumbersOfItems() {
        // WHEN
        let itemsInRow = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)

        // THEN
        XCTAssertEqual(itemsInRow, viewModel.numberOfItems())
    }

//    func testCellForRow_ConvertImageFailed() {
//        // GIVEN
//        collectionView = UICollectionView(frame: .zero,
//                                          collectionViewLayout: type(of: UICollectionViewLayout()).init())
//        collectionView.register(PhotoAlbumCell.self, forCellWithReuseIdentifier: "PhotoCell")
//
//
//        let placeholder = UIImage(named: "photo-paceholder")
//
//        // WHEN
//        let indexPath = IndexPath(item: 0, section: 0)
//        let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath) as! PhotoAlbumCell
//
//        // THEN
//
//        XCTAssertEqual(cell.imageView.image, placeholder)
//    }
//
//    func testCellForRow_ConvertImageSuccess() {
//        // GIVEN
//
//        // WHEN
//
//        // THEN
//
//    }
}
