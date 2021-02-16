import Foundation
import CryptoKit

// CryptoKit.Digest extension
// let digest = SHA256.hash(data: data)
// digest.data -> 32bytes
// digest.hexStr -> B94D27B9934D3E08A52E52D7DA7DABFAC484EFE37A5380EE9088F7ACE2EFCDE9
extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}
