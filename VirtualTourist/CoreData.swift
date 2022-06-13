import UIKit

class CoreData: Database {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var pins: [Pin]?
    var photos: [Image]?

    func fetch() {
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

    func save() {
        do {
            try context.save()
        } catch {
            //TODO: Handle error
        }
    }
}
