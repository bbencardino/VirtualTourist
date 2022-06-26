import MapKit
import UIKit

class PhotoAlbumViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectButton: UIButton!
    
    var viewModel: PhotoAlbumViewModel!

    lazy var photoAlbumDataSource = PhotoAlbumDataSource(viewModel: viewModel)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoAlbumDataSource
        configurePhotoAlbumLayout()
        viewModel.reloadView = reloadData

        viewModel.fetchPhotos()
    }

    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.newCollectButton.isEnabled = self.viewModel.isNewCollectionEnabled
        }
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
}
