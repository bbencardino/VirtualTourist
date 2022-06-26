import UIKit

final class PhotoAlbumViewModel {

    private let service: RepositoryProtocol
    private let database: Database
    private var photosFromAPI: [Photo] = []

    private let album: Album
    private var albumStatus: PhotoAlbumStatus {
        PhotoAlbumStatus(rawValue: album.status ?? "") ?? .notStarted
    }
    var isNewCollectionEnabled: Bool { albumStatus == .done }

    var reloadView: (() -> Void)?

    private var cachedImages: [Image] {

        guard let imagesFromPhotoAlbum = album.images,
              imagesFromPhotoAlbum.allObjects.isEmpty == false,
              let images = imagesFromPhotoAlbum.allObjects as? [Image] else {
            return []
        }
        return images
    }

    var latitude: Double
    var longitude: Double

    init(photoAlbum: Album,
         service: RepositoryProtocol,
         database: Database,
         latitude: Double,
         longitude: Double) {
        self.album = photoAlbum
        self.service = service
        self.database = database
        self.latitude = latitude
        self.longitude = longitude
    }

    // MARK: - Networking

    func getPhotosFromFlickr(_ completion: @escaping () -> Void) {
        service.getImages(latitude: latitude, longitude: longitude, pageNumber: 1) { result in
            switch result {
            case .success(let photos):
                self.photosFromAPI = photos.photo
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: Show alert
            }
        }
    }

    // MARK: - Data Source
    func numberOfItems() -> Int {
        // TODO: next story implement label
        return albumStatus == .done ? cachedImages.count : photosFromAPI.count
    }

    func image(at index: Int) -> UIImage? {

        if albumStatus == .done {
            let sortedImages = cachedImages.sorted { $0.id > $1.id }

            guard
                let blob = sortedImages[index].blob else { return nil }
            return UIImage(data: blob)

        } else {

            let id = Int(photosFromAPI[index].id)!
            guard
                let cacheImage = cachedImages.first(where: { $0.id == id }),
                let blob = cacheImage.blob
            else { return nil }
            return UIImage(data: blob)
        }
    }

    private func getImageName(from photo: Photo) -> String {
         "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }

    // download all photos in one go.
    func downloadImages(_ completion: @escaping (Result<Void, Error>) -> Void) {
        changeAlbumStatus(to: .downloading)
        let imagesInAlbum = cachedImages.map { $0.id }

        photosFromAPI.forEach { photo in
            guard let id = Int64(photo.id) else { return }

            if imagesInAlbum.contains(id) {
                self.reloadView?()
            } else {
                let imageName = getImageName(from: photo)
                guard let url = URL(string: imageName),
                   let data = service.downloadContent(from: url) else {
                    completion(.failure(NSError(domain: "🤯", code: 24)))
                    return
                }
                self.database.createImage(for: self.album,
                                          blob: data,
                                          url: imageName,
                                          id: id)
                self.reloadView?()
            }
        }
        changeAlbumStatus(to: .done)
        completion(.success(()))
    }

    private func changeAlbumStatus(to status: PhotoAlbumStatus) {

        // 1. database must be updated
        database.changeStatus(of: album, to: status)
        // 2. should notify view controller
        reloadView?()
    }

    func showPhotos(_ completion: @escaping () -> Void) {
        albumStatus == .done ? reloadView?() : getPhotosFromFlickr(completion)
    }

    func createNewCollection() {
        // 1.empty album
        guard let imagesToDelete = album.images else { return }
        album.removeFromImages(imagesToDelete)
        changeAlbumStatus(to: .notStarted)
        photosFromAPI.removeAll()

        // 2.new photos are downloaded

        // 3.disable button

        // 4.change album status

    }
}
