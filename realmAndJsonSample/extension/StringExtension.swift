import Foundation

extension String {

    func convertUtf8() -> String? {
        var bytes = [UInt8]()
        let firstIndex = self.startIndex
        for idx in stride(from: 0, to: self.count, by: 2) {
            let startIndex = self.index(firstIndex, offsetBy: idx)
            let endIndex = self.index(firstIndex, offsetBy: idx + 2)
            guard let convertValue = UInt8(self[startIndex..<endIndex], radix: 16) else {
                continue
            }
            bytes.append(convertValue)
        }
        return String(bytes: bytes, encoding: .utf8)
    }
}
