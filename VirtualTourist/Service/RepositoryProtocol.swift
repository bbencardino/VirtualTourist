import Foundation

// swiftlint: disable todo
// TODO: Think in a better name lol 🥲
protocol RepositoryProtocol {
    func getImages(latitude: Double,
                   longitude: Double,
                   pageNumber: Int,
                   completion: @escaping (Result<Photos, NetworkError>) -> Void)
    func downloadContent(from url: URL) -> Data?
}
