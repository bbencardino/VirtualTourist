import Foundation
@testable import VirtualTourist

struct MockDataFactory {

    private let coreDataManager = CoreDataManager(context: TestCoreDataStack().context)

     func makeAlbum() throws -> Album {

         coreDataManager.createPin(latitude: -45.7677, longitude: -32.6896)
         guard let album = coreDataManager.pins?.first?.album else { fatalError("Error: No album available") }
         return album
    }
}
