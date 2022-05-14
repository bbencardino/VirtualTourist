import Foundation

protocol UserDefaultsProtocol {
    func write<T>(_ value: T, forKey key: String)
    func readDouble(forKey key: String) -> Double
    func readBool(forKey key: String) -> Bool
}
