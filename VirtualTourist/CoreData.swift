import UIKit
import CoreData

final class CoreData: Database {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var pins: [Pin]?
    var images: [Image]?
    var photoAlbum: Album?

    func fetchPins() {
        do {
            pins = try context.fetch(Pin.fetchRequest())
        } catch {
            // TODO: Handle error
        }
    }

    func createPin(latitude: Double, longitude: Double) -> Pin {
        let newPin = Pin(context: context)
        newPin.latitude = latitude
        newPin.longitude = longitude
        save()
        return newPin
    }

    func getImage(at path: String) -> Data? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
            fetchRequest.predicate = NSPredicate(format: "url == %@", path)
            return (try context.fetch(fetchRequest) as? [Image])?.first?.blob
        } catch {
            return nil
        }
    }

    func createImage(blob: Data, url: String) {
        context.performAndWait {
            let newImage = Image(context: context)
            newImage.blob = blob
            newImage.url = url
            save()
        }
    }

    func createPhotoAlbum(status: PhotoAlbumStatus, pin: Pin) {
        context.performAndWait {
            let newAlbum = Album(context: context)
            newAlbum.status = status.rawValue
            newAlbum.pin = pin
            save()
        }
    }

    private func save() {
        do {
            try context.save()
        } catch {
            // TODO: Handle error
        }
    }
}
