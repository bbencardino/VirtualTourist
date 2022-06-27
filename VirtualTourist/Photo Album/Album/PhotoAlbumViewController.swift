import MapKit
import UIKit

class PhotoAlbumViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var noImageView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectButton: UIButton!

    var viewModel: PhotoAlbumViewModel!

    lazy var photoAlbumDataSource = PhotoAlbumDataSource(viewModel: viewModel)
    lazy var photoAlbumDelegate = PhotoAlbumDelegate(viewModel: viewModel)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoAlbumDataSource
        collectionView.delegate = photoAlbumDelegate
        configurePhotoAlbumLayout()
        setupMapView()

        viewModel.reloadView = reloadData
        viewModel.fetchPhotos()
    }

    @IBAction func createNewCollection(_ sender: UIButton) {
        viewModel.createNewCollection()
    }

    // MARK: - Private Methods
    private func configurePhotoAlbumLayout() {

        let space: CGFloat = 3
        let dimension = (view.frame.size.width - (2 * space)) / space

        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateView()
        }
    }

    private func updateView() {
        noImageView.isHidden = viewModel.isNoImageViewHidden
        newCollectButton.isEnabled = viewModel.isNewCollectionEnabled
    }

    private func setupMapView() {
        let coordinate = CLLocationCoordinate2D(latitude: viewModel.latitude,
                                                longitude: viewModel.longitude)
        let region = MKCoordinateRegion(center: coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                               longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
    }
}
