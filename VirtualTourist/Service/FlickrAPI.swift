import Foundation

final class FlickrAPI: RepositoryProtocol {

    struct Auth {
        static var key = "52a0ae9dd211d0c26dc01eb7d5b5abec"
    }

    enum Endpoint {
        static let baseString = "https://www.flickr.com/services/"
    }

    func getImages(latitude: Double,
                   longitude: Double,
                   pageNumber: Int,
                   completion: @escaping (Result<Photos, NetworkError>) -> Void) {
        let photosString = Endpoint.baseString +
        "rest/?method=flickr.photos.search" +
        "&api_key=\(Auth.key)" +
        "&lat=\(latitude)" +
        "&lon=\(longitude)" +
        "&page=\(pageNumber)" +
        "&per_page=18" +
        "&format=json&nojsoncallback=1"

        guard let url = URL(string: photosString) else { fatalError("🤯: Wrong URL") }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(.failure(.badURL))
                return
            }

            let decoder = JSONDecoder()
            do {
                let photoAlbum = try decoder.decode(PhotoAlbum.self, from: data)
                completion(.success(photoAlbum.photos))

            } catch {
                completion(.failure(.serviceError))
            }
        }
        dataTask.resume()
    }

    func downloadContent(from url: URL) -> Data? {
        try? Data(contentsOf: url)
    }
}
