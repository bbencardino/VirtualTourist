import UIKit

class PhotoAlbumDataSource: NSObject, UICollectionViewDataSource {

    let placeholder = UIImage(named: "photo-paceholder")
    let images: [UIImage] = []

    let viewModel: PhotoAlbumViewModel
    init(viewModel: PhotoAlbumViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // swiftlint: disable line_length 
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoAlbumCell else {
            fatalError("error: collection view cell is not a type of PhotoAlbumCell")
        }

        cell.imageView.image = viewModel.image(at: indexPath.row) ?? placeholder

        return cell
    }
}
