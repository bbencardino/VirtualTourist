import Foundation

// MARK: - PhotoAlbum
class PhotoAlbum: Codable {
    let photos: Photos
    let stat: String

    init(photos: Photos, stat: String) {
        self.photos = photos
        self.stat = stat
    }
}

// MARK: - Photos
class Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]

    init(page: Int, pages: Int, perpage: Int, total: Int, photo: [Photo]) {
        self.page = page
        self.pages = pages
        self.perpage = perpage
        self.total = total
        self.photo = photo
    }
}

// MARK: - Photo
class Photo: Codable {
    let id, secret, server: String
    let title: String

    init(id: String, secret: String, server: String, title: String) {
        self.id = id
        self.secret = secret
        self.server = server
        self.title = title

    }
}
