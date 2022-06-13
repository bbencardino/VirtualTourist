import Foundation

protocol Database {

    func fetch()
    func createPin(latitude: Double, longitude: Double)
    func save()
    var pins: [Pin]? { get set }
    var photos: [Image]? { get set }
}
