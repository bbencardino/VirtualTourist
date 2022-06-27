import UIKit

final class PhotoAlbumDelegate: NSObject, UICollectionViewDelegate {
    private let viewModel: PhotoAlbumViewModel

    init(viewModel: PhotoAlbumViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.deleteImage(at: indexPath.row)
    }
}
