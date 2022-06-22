import Foundation

protocol Database {
    func fetchPins()
    func getImage(at path: String) -> Data?
    func createPin(latitude: Double, longitude: Double) -> Pin
    func createImage(blob: Data, url: String)
    func createPhotoAlbum(status: PhotoAlbumStatus, pin: Pin)
    var pins: [Pin]? { get set }
    var images: [Image]? { get set }
    var photoAlbum: Album? { get set }
}
