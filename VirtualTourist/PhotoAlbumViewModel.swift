import Foundation

class PhotoAlbumViewModel {

    // MARK: - Data Source
    func numberOfItems() -> Int {
        // next story: grabing it from the API call
        return 20
    }

    func getImageName() -> String {
        // placeholders -> change the return type!
        // next story: grab it from the API call
        return "photo-paceholder"
    }
}
