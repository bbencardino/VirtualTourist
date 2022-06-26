import Foundation

protocol Database {

    func getImage(at path: String) -> Data?
    func createPin(latitude: Double, longitude: Double)
    func createImage(for album: Album, blob: Data, url: String, id: Int64)
    func changeStatus(of album: Album, to status: PhotoAlbumStatus)
    var pins: [Pin]? { get }
    var images: [Image]? { get set }
}
