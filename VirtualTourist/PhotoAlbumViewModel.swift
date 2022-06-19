import UIKit

final class PhotoAlbumViewModel {

    private var service: RepositoryProtocol
    private var database: Database
    private var photos: [Photo] = []
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

    // MARK: - Data Source
    func numberOfItems() -> Int {
        photos.count
    }

    func image(at index: Int, completion: @escaping (UIImage?) -> Void) {

        let path = getImageName(from: photos[index])

        if let blob = database.getImage(at: path) {
            completion(UIImage(data: blob))
        } else {
            downloadImage(path: path) { result in
                switch result {
                case .success(let data):
                    completion(UIImage(data: data))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func getImageName(from photo: Photo) -> String {

         "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }

    func downloadImage(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global().async {

            guard let url = URL(string: path),
                  let data = self.service.downloadContent(from: url) else {
                completion(.failure(NSError(domain: "🤯", code: 24)))
                return
            }
            self.database.createImage(blob: data, url: path)
            completion(.success(data))
        }
    }
}
