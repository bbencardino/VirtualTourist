import XCTest
@testable import VirtualTourist

class TravelLocationViewModelTests: XCTestCase {

    var viewModel: TravelLocationViewModel!
    var mockedUserDefaults: UserDataMocked!

    override func setUpWithError() throws {
        mockedUserDefaults = UserDataMocked(loaded: true)
        viewModel = TravelLocationViewModel(userDefaults: mockedUserDefaults!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocationHasntBeenLoaded() {
        // GIVEN
        let viewModel = TravelLocationViewModel(userDefaults: UserDataMocked(loaded: false))
        // THEN
        XCTAssertEqual(viewModel.center.longitude, -43.365894)
    }

    func testLocationHasBeenLoaded() {
        // GIVEN
        let loadedUserDefaults = UserDataMocked(loaded: true)
        loadedUserDefaults.write(-42.0, forKey: "latitude")
        loadedUserDefaults.write(33.0, forKey: "longitude")

        // WHEN
        let viewModel = TravelLocationViewModel(userDefaults: loadedUserDefaults)

        // THEN
        XCTAssertEqual(viewModel.center.latitude, -42)
        XCTAssertEqual(viewModel.center.longitude, 33)
    }

    func testCenterPreferencesHasBeenSaved() {
        // WHEN
        viewModel.saveCenterPreferences(latitude: 57.0, longitude: 77.0)

        // THEN
        XCTAssertEqual(mockedUserDefaults.readDouble(forKey: "latitude"), 57)
        XCTAssertEqual(mockedUserDefaults.readDouble(forKey: "longitude"), 77)
    }

    func testSaveSpanPreferencesHasBeenSaved() {
        // WHEN
        viewModel.saveSpanPreferences(latitudeDelta: 0.5, longitudeDelta: -0.5)
        // THEN
        XCTAssertEqual(mockedUserDefaults.readDouble(forKey: "latitudeDelta"), 0.5)
        XCTAssertEqual(mockedUserDefaults.readDouble(forKey: "longitudeDelta"), -0.5)
    }
}
