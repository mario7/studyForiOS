import Foundation
import CoreNFC

class NFCReader: NSObject {
    static let shard = NFCReader()
    
    func nfcScan() {
        guard NFCTagReaderSession.readingAvailable,
              let session = NFCTagReaderSession(pollingOption: [.iso18092, .iso14443],
                                                delegate: self) else {
            return
        }
        session.alertMessage = "start scan"
        session.begin()
    }
    
    private func felicaTagSelected(session: NFCTagReaderSession,
                                   tag: NFCFeliCaTag) {
        let cardId = tag.currentIDm.map { String(format: "%.2hhx", $0) }.joined()
        debugPrint(cardId)
        session.alertMessage = " scan success (felica)"
        session.invalidate()
    }
    
    private func miFareTagSelected(session: NFCTagReaderSession,
                                   tag: NFCMiFareTag) {
        let cardId = tag.identifier.map { String(format: "%.2hhx", $0) }.joined(separator: ":")
        debugPrint(cardId)
        session.alertMessage = " scan success (mifare)"
        session.invalidate()
    }
    
}

extension NFCReader: NFCTagReaderSessionDelegate {
    //読み取り状態になったとき
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        debugPrint(#function)
    }
    
    //読み取りが成功したとき
    func tagReaderSession(_ session: NFCTagReaderSession,
                          didDetect tags: [NFCTag]) {
        debugPrint(#function)
        guard let selectedTag = tags.first else { return }
        
        session.connect(to: selectedTag) { [weak self] error in
            guard error == nil else { return }
            
            switch selectedTag {
            case let NFCTag.feliCa(tag):
                self?.felicaTagSelected(session: session, tag: tag)
            case let NFCTag.miFare(tag):
                self?.miFareTagSelected(session: session, tag: tag)
            default:
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 500) {
                    session.restartPolling()
                }
            }
        }
    }
    //読み取りが完了したとき(理由)
    func tagReaderSession(_ session: NFCTagReaderSession,
                          didInvalidateWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}
