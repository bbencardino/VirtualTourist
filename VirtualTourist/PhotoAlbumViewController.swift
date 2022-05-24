import MapKit
import UIKit

class PhotoAlbumViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var viewModel: PhotoAlbumViewModel!
    lazy var photoAlbumDataSource = PhotoAlbumDataSource(viewModel: viewModel)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoAlbumDataSource
        configurePhotoAlbum()
    }

    @IBAction func createNewCollection(_ sender: UIButton) {}

    // MARK: - Private Methods
    private func configurePhotoAlbum() {

        let space: CGFloat = 3
        let dimension = (view.frame.size.width - (2 * space)) / space

        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
