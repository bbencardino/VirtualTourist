import UIKit

final class PhotoAlbumViewModel {

    private let service: RepositoryProtocol
    private let database: Database
    private var photosFromAPI: [Photo] = []

    private var totalPhotos: Int = 0
    private var maxPages: Int?
    private var pageNumber: Int {
        let maxPages = maxPages ?? 1
        return Int.random(in: 1...maxPages)
    }

    private let album: Album
    private var albumStatus: PhotoAlbumStatus {
        PhotoAlbumStatus(rawValue: album.status ?? "") ?? .notStarted
    }
    var isNewCollectionEnabled: Bool { albumStatus == .done }
    var isNoImageViewHidden: Bool {
        !(totalPhotos == 0 && albumStatus != .done)
    }

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

        service.getImages(latitude: latitude, longitude: longitude, pageNumber: pageNumber) { result in
            switch result {
            case .success(let photos):
                self.totalPhotos = photos.total
                self.maxPages = photos.pages
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
        albumStatus == .done ? cachedImages.count : photosFromAPI.count
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

    // MARK: - Photos
    func fetchPhotos() {
        if albumStatus == .done {
            reloadView?()

        } else {
            getPhotosFromFlickr {
                self.reloadView?()
                self.downloadImages { _ in }
            }
        }
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
            changeAlbumStatus(to: .done)
        }

        completion(.success(()))
    }
    // MARK: - Album

    func createNewCollection() {
        // 1.empty album
        database.deleteImages(from: album)
        changeAlbumStatus(to: .notStarted)
        photosFromAPI.removeAll()

        // 2.disable button
        reloadView?()

        // 3.new photos are downloaded
        fetchPhotos()
    }

    // MARK: - Helper methods
    private func getImageName(from photo: Photo) -> String {
         "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }

    private func changeAlbumStatus(to status: PhotoAlbumStatus) {

        // 1. database must be updated
        database.changeStatus(of: album, to: status)
        // 2. should notify view controller
        reloadView?()
    }
}
