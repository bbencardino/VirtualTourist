import Foundation

protocol Database {
    func fetchPins()
    func getImage(at path: String) -> Data?
    func createPin(latitude: Double, longitude: Double)
    func createImage(blob: Data, url: String)
    var pins: [Pin]? { get set }
    var images: [Image]? { get set }
}
