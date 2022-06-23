import UIKit
import CoreData

final class CoreData: Database {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var pins: [Pin]? { try? context.fetch(Pin.fetchRequest()) }
    var images: [Image]?
    

    func createPin(latitude: Double, longitude: Double) {
        let newPin = Pin(context: context)
        newPin.latitude = latitude
        newPin.longitude = longitude
        createPhotoAlbum(status: .notStarted, pin: newPin)
        save()
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

    func createImage(for album: Album, blob: Data, url: String, id: String) {
        context.performAndWait {
            let newImage = Image(context: context)
            newImage.blob = blob
            newImage.url = url
            newImage.id = id
            album.addToImages(newImage)
            save()
        }
    }

    func changeStatus(of album: Album, to status: PhotoAlbumStatus) {
        album.status = status.rawValue
        save()
    }

    private func createPhotoAlbum(status: PhotoAlbumStatus, pin: Pin) {
        context.performAndWait {
            let newAlbum = Album(context: context)
            newAlbum.status = status.rawValue
            newAlbum.pin = pin
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
