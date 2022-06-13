import Foundation

class PhotoAlbumViewModel {

    var service: RepositoryProtocol
    var database: Database
    var latitude: Double
    var longitude: Double

    init(service: RepositoryProtocol, database: Database, latitude: Double, longitude: Double) {
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
                self.photos = photos.photo
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: Show alert
            }
        }
    }

    var photos: [Photo] = []

    // MARK: - Data Source
    func numberOfItems() -> Int {
        photos.count
    }

    func getImageNames() -> [String] {
        var imageNames: [String] = []
        photos.forEach { photo in
            imageNames.append("https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg")
        }
        return imageNames
    }

    func downloadImages(completion: @escaping ([Data?]) -> Void) {
        DispatchQueue.global().async {
            let urls = self.getImageNames().map { URL(string: $0)! }
            let data = urls.map { self.service.downloadContent(from: $0)}
            completion(data)
        }
    }
}
