import Foundation
@testable import VirtualTourist

final class UserDataMocked: UserDefaultsProtocol {

    private var localStorage: [String: Any] = [:]

    let loaded: Bool
    init(loaded: Bool) {
        self.loaded = loaded
    }

    func write<T>(_ value: T, forKey key: String) {
        localStorage[key] = value
    }

    func readDouble(forKey key: String) -> Double {
        return localStorage[key] as? Double ?? 0.0
    }

    func readBool(forKey key: String) -> Bool {
        return loaded
    }
}
