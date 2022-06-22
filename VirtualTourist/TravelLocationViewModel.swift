import MapKit
import CoreLocation

class TravelLocationViewModel {

    let userDefaults: UserDefaultsProtocol
    private let database: Database
    var pins: [Pin]? { database.pins }

    let zoomLevel: MKCoordinateSpan
    let center: CLLocationCoordinate2D
    private let rioLat = -23.000372
    private let rioLong = -43.365894

    init(userDefaults: UserDefaultsProtocol = UserDataDefaults(),
         database: Database = CoreData()) {
        self.userDefaults = userDefaults
        self.database = database

        let latitude = userDefaults.readDouble(forKey: "latitude")
        let longitude = userDefaults.readDouble(forKey: "longitude")
        let latDelta = userDefaults.readDouble(forKey: "latitudeDelta")
        let longDelta = userDefaults.readDouble(forKey: "longitudeDelta")

        if userDefaults.readBool(forKey: "locationHasBeenLoaded") {
            zoomLevel = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        } else {
            zoomLevel = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            center = CLLocationCoordinate2D(latitude: rioLat, longitude: rioLong)
        }
    }

    // MARK: - User Defaults
    func saveLocationHasBeenLoaded() {
        userDefaults.write(true, forKey: "locationHasBeenLoaded")
    }

    private func saveCenterPreferences(latitude: Double, longitude: Double) {
        userDefaults.write(latitude, forKey: "latitude")
        userDefaults.write(longitude, forKey: "longitude")
    }

    private func saveSpanPreferences(latitudeDelta: Double, longitudeDelta: Double) {
        userDefaults.write(latitudeDelta, forKey: "latitudeDelta")
        userDefaults.write(longitudeDelta, forKey: "longitudeDelta")
    }

    func saveLastPosition(region: MKCoordinateRegion) {

        saveCenterPreferences(latitude: region.center.latitude,
                              longitude: region.center.longitude)
        saveSpanPreferences(latitudeDelta: region.span.latitudeDelta,
                            longitudeDelta: region.span.longitudeDelta)
    }

    // MARK: - Map View
    func plotNewPin(coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        let annotation = createAnnotation(coordinate: coordinate)
        mapView.addAnnotation(annotation)
    }

    func createAnnotation(coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        let pin = database.createPin(latitude: coordinate.latitude,
                                     longitude: coordinate.longitude)
        createPhotoAlbum(for: pin)
        return annotation
   }

    // MARK: - Database

    func fetchPins() {
        database.fetchPins()
    }

    func createPhotoAlbum(for pin: Pin) {
        database.createPhotoAlbum(status: PhotoAlbumStatus.notStarted, pin: pin)
    }

    // MARK: - Navigation
    func makePhotoAlbumViewModel() -> PhotoAlbumViewModel {
        PhotoAlbumViewModel(service: FlickrAPI(),
                                   database: database,
                                   latitude: center.latitude,
                                   longitude: center.longitude)
    }
}
