import MapKit
import CoreLocation

class TravelLocationViewModel {
    let userDefaults: UserDefaultsProtocol
    let zoomLevel: MKCoordinateSpan
    let center: CLLocationCoordinate2D
    private let rioLat = -23.000372
    private let rioLong = -43.365894

    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults

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

    func saveCenterPreferences(latitude: Double, longitude: Double) {
        userDefaults.write(latitude, forKey: "latitude")
        userDefaults.write(longitude, forKey: "longitude")
    }

    func saveSpanPreferences(latitudeDelta: Double, longitudeDelta: Double) {
        userDefaults.write(latitudeDelta, forKey: "latitudeDelta")
        userDefaults.write(longitudeDelta, forKey: "longitudeDelta")
    }

    // MARK: - Map View

    func plotNewPin(coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        let pin = createAnnotation(coordinate: coordinate)
        mapView.addAnnotation(pin)
    }

    private func createAnnotation(coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        return annotation
    }
}
