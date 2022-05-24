import Foundation
@testable import VirtualTourist

class MockRepository: RepositoryProtocol {
    func getImages() {
        print("ella")
    }
}
