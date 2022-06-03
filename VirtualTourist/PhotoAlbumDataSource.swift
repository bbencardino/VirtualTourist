import UIKit

class PhotoAlbumDataSource: NSObject, UICollectionViewDataSource {

    let placeholder = UIImage(named: "photo-paceholder")

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

        cell.imageView.image = placeholder

        convertImages { result in
            switch result {
            case .success(let images):
                DispatchQueue.main.async {
                    cell.imageView.image = images[indexPath.row]
                }
            case .failure:
                DispatchQueue.main.async {
                    cell.imageView.image = self.placeholder
                }
            }
        }

        return cell
    }
    // MARK: - Update functions

    private func convertImages(completion: @escaping (Result<[UIImage], Error>) -> Void) {
        var images: [UIImage] = []

        viewModel.downloadImages { imagesData in

           images = imagesData.compactMap { data in
               guard let data = data else { return nil}
               return UIImage(data: data)
           }

            if images.isEmpty {
                completion(.failure(NetworkError.noData))
            } else {
                completion(.success(images))
            }
        }
    }
}
