import XCTest
import MapKit
@testable import VirtualTourist

class TravelLocationViewModelTests: XCTestCase {

    var viewModel: TravelLocationViewModel!
    var mockedUserDefaults: UserDataMocked!
    var mockCoreDataManager: CoreDataManager!

    override func setUpWithError() throws {

        mockCoreDataManager = CoreDataManager(context: TestCoreDataStack.context)

        mockedUserDefaults = UserDataMocked(loaded: true)
        viewModel = TravelLocationViewModel(userDefaults: mockedUserDefaults!, database: mockCoreDataManager)
    }

    func testLocationHasntBeenLoaded() {
        // GIVEN
        let viewModel = TravelLocationViewModel(userDefaults: UserDataMocked(loaded: false),
                                                database: mockCoreDataManager)
        // THEN
        XCTAssertEqual(viewModel.center.longitude, -43.365894)
    }

    func testLocationHasBeenLoaded() {
        // GIVEN
        let loadedUserDefaults = UserDataMocked(loaded: true)
        loadedUserDefaults.write(-42.0, forKey: "latitude")
        loadedUserDefaults.write(33.0, forKey: "longitude")

        // WHEN
        let viewModel = TravelLocationViewModel(userDefaults: loadedUserDefaults, database: mockCoreDataManager)

        // THEN
        XCTAssertEqual(viewModel.center.latitude, -42)
        XCTAssertEqual(viewModel.center.longitude, 33)
    }

    func testSaveLastPosition() {
        // GIVEN
        let zoomLevel = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: -0.5)
        let center = CLLocationCoordinate2D(latitude: 57.0, longitude: 77.0)
        let region = MKCoordinateRegion(center: center, span: zoomLevel)

        // WHEN
        viewModel.saveLastPosition(region: region)

        // THEN
        XCTAssertEqual(mockedUserDefaults.readDouble(forKey: "latitude"), 57)
        XCTAssertEqual(mockedUserDefaults.readDouble(forKey: "longitude"), 77)
        XCTAssertEqual(mockedUserDefaults.readDouble(forKey: "latitudeDelta"), 0.5)
        XCTAssertEqual(mockedUserDefaults.readDouble(forKey: "longitudeDelta"), -0.5)
    }
}
