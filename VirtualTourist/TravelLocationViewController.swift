import UIKit
import MapKit

class TravelLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private let viewModel = TravelLocationViewModel(userDefaults: UserDataDefaults())

    override func viewDidLoad() {
        super.viewDidLoad()
        print(mapView.region.center)

        mapView.region.center = viewModel.center
        mapView.region.span = viewModel.zoomLevel

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
}
