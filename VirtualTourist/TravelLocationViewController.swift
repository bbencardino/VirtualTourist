import UIKit
import MapKit

final class TravelLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private let viewModel: TravelLocationViewModel
    private let database: Database

    required init?(coder: NSCoder, viewModel: TravelLocationViewModel, database: Database) {
        self.viewModel = viewModel
        self.database = database
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:viewModel:)` to instantiate a `ViewController` instance.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.region.center = viewModel.center
        mapView.region.span = viewModel.zoomLevel
        viewModel.saveLocationHasBeenLoaded()
        database.fetchPins()
        setMapView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let center = mapView.region.center
        let span = mapView.region.span
        viewModel.saveCenterPreferences(latitude: center.latitude,
                                        longitude: center.longitude)
        viewModel.saveSpanPreferences(latitudeDelta: span.latitudeDelta,
                                      longitudeDelta: span.longitudeDelta)
        database.save()
    }

    // MARK: - MapView

    private func setMapView() {
        mapView.delegate = self

        if let pins = database.pins {
            var annotations: [MKAnnotation] = []
            pins.forEach { pin in
                let coordinate = CLLocationCoordinate2D(latitude: pin.latitude,
                                                        longitude: pin.longitude)
                annotations.append(viewModel.createAnnotation(coordinate: coordinate))
            }
            mapView.addAnnotations(annotations)
        }

        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(longPressAction(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPress)
    }

    @objc private func longPressAction(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UILongPressGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: mapView)

            // convert CGPoint to CLLocationCoordinate2D
            let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            viewModel.plotNewPin(coordinate: coordinate,
                                 mapView: mapView)
        }
    }
    // MARK: - Photo Album View Model

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoAlbum" {
            guard let destination = segue.destination as? PhotoAlbumViewController else { return }
            destination.viewModel = makePhotoAlbumViewModel()
        }
    }

    private func makePhotoAlbumViewModel() -> PhotoAlbumViewModel {
        return PhotoAlbumViewModel(service: FlickrAPI(),
                                   database: CoreData(),
                                   latitude: viewModel.center.latitude,
                                   longitude: viewModel.center.longitude)
    }
}
// MARK: - Map View Delegate
extension TravelLocationViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "toPhotoAlbum", sender: nil)
    }
}
