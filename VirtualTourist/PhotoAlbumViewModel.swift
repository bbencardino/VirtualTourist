import UIKit

final class PhotoAlbumViewModel {

    private let service: RepositoryProtocol
    private let database: Database
    private var photosFromAPI: [Photo] = []
    private let album: Album
    var isNewCollectionEnabled: Bool {
        let status = PhotoAlbumStatus(rawValue: album.status ?? "")
        return status == .done
    }
    var reloadView: (() -> Void)?

    private var cachedImages: [Image] {
         if let imagesFromPhotoAlbum = album.images {
            let img = imagesFromPhotoAlbum.allObjects as! [Image]
            return img.sorted { $0.id > $1.id }
        }
        return []
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

    func getPhotosFromFlickr(completion: @escaping () -> Void) {
        service.getImages(latitude: latitude, longitude: longitude) { result in
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
         photosFromAPI.count
    }

    func image(at index: Int) -> UIImage? {
        let id = photosFromAPI[index].id

        guard
            let cacheImage = cachedImages.first { $0.id == id },
            let path = cacheImage.url,
            let blob = cacheImage.blob
        else { return nil }
        return UIImage(data: blob)
    }

    private func getImageName(from photo: Photo) -> String {
         "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }

    // download all photos in one go.
    func downloadImages(completion: @escaping (Result<Void, Error>) -> Void) {
        changeAlbumStatus(to: .downloading)
        photosFromAPI.forEach { photo in
            let imageName = getImageName(from: photo)
            guard let url = URL(string: imageName),
               let data = service.downloadContent(from: url) else {
                completion(.failure(NSError(domain: "🤯", code: 24)))
                return
            }
            self.database.createImage(for: self.album, blob: data, url: imageName, id: photo.id)
            self.reloadView?()
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
}
