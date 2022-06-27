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

    func getImages(from albumID: UUID) -> [Image]? {
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "album.id == %@", albumID.uuidString)
        return try? context.fetch(fetchRequest) as? [Image]
    }

    func createImage(for album: Album, blob: Data, url: String, id: Int64) {
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

    func deleteImages(from album: Album) {
        guard let id = album.id else { return }
        let imagesToDelete = getImages(from: id)

        imagesToDelete?.forEach({ image in
            context.delete(image)
        })

        save()
    }

    func deleteImage(_ image: Image) {

        context.delete(image)
        save()
    }

    // MARK: - Helper functions
    private func createPhotoAlbum(status: PhotoAlbumStatus, pin: Pin) {
        context.performAndWait {
            let newAlbum = Album(context: context)
            newAlbum.id = UUID()
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
