import Foundation
@testable import VirtualTourist

class MockRepository: RepositoryProtocol {

    func getImages(latitude: Double,
                   longitude: Double,
                   pageNumber: Int,
                   completion: @escaping (Result<Photos, NetworkError>) -> Void) {
        let photoArray = [Photo(id: "1234", secret: "1234", server: "1232"),
                          Photo(id: "14234", secret: "12f34", server: "12d32"),
                          Photo(id: "123f4", secret: "1234", server: "123f2"),
                          Photo(id: "1234", secret: "1234", server: "12432")]
        let photos = Photos(page: 1, pages: 1, perpage: 1, total: 1, photo: photoArray)

        completion(.success(photos))
    }

    func downloadContent(from url: URL) -> Data? {

        Data(url.absoluteString.utf8)
    }
}
