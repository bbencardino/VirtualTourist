import Foundation

protocol RepositoryProtocol {
    func getImages(latitude: Double,
                   longitude: Double,
                   pageNumber: Int,
                   completion: @escaping (Result<Photos, NetworkError>) -> Void)
    func downloadContent(from url: URL) -> Data?
}
