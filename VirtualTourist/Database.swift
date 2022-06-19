import Foundation

protocol Database {

    func fetchPins()
    func fetchImages()
    func createPin(latitude: Double, longitude: Double)
    func createImage(blob: Data, url: String)
    func save()
    var pins: [Pin]? { get set }
    var images: [Image]? { get set }
}
