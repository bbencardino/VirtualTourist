import UIKit
import CoreData

class CoreData: Database {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var pins: [Pin]?
    var images: [Image]?

    func fetchPins() {
        do {
            pins = try context.fetch(Pin.fetchRequest())
        } catch {
            //TODO: Handle error
        }
    }

    func createPin(latitude: Double, longitude: Double) {

        let newPin = Pin(context: context)
        newPin.latitude = latitude
        newPin.longitude = longitude
    }

    func fetchImages() {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
            images = try context.fetch(fetchRequest) as! [Image]
        } catch {
            //TODO: Handle error
        }
    }

    func createImage(blob: Data, url: String) {
        let newImage = Image(context: context)
        newImage.blob = blob
        newImage.url = url
    }

    func save() {
        do {
            try context.save()
        } catch {
            //TODO: Handle error
        }
    }
}
