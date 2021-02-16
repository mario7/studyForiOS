import Foundation

extension Data {
    var hexDescription: String {
        return map { String (format: "%02hhx", $0) }.joined()
    }
}
