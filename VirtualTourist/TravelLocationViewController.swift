import UIKit
import MapKit

class TravelLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private let viewModel = TravelLocationViewModel(userDefaults: UserDataDefaults())

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.region.center = viewModel.center
        mapView.region.span = viewModel.zoomLevel
        setMapView()
        viewModel.saveLocationHasBeenLoaded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let center = mapView.region.center
        let span = mapView.region.span
        viewModel.saveCenterPreferences(latitude: center.latitude,
                                       longitude: center.longitude)
        viewModel.saveSpanPreferences(latitudeDelta: span.latitudeDelta, longitudeDelta: span.longitudeDelta)
    }

    // MARK: - MapView

    private func setMapView() {
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(longPressAction(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPress)
    }

     @objc private func longPressAction(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UILongPressGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: mapView)

            //convert CGPoint to CLLocationCoordinate2D
            let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            viewModel.plotNewPin(coordinate: coordinate,
                                 mapView: mapView)
        }
    }
}
