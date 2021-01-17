//
//  KeychainAccess.swift
//  KeychainSample
//
//  Created by snowman on 2021/01/17.
//

import Foundation

class KeychainAccess {
    
    // 保存処理
    static func saveKeyChain(key: String, vaule: String) {
        // 保存する文字列
        guard let data = vaule.data(using: .utf8) else {
            return
        }

        let dic: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                  kSecAttrGeneric as String: key,           // 自由項目（グループ）
                                  kSecAttrAccount as String: "snowman",     // アカウント（ログインIDなど）
                                  kSecValueData as String: data]            // 保存情報

        var itemAddStatus: OSStatus?
        // 保存データが存在するかの確認
        let matchingStatus = SecItemCopyMatching(dic as CFDictionary, nil)
        switch matchingStatus {
        // 保存
        case errSecItemNotFound: itemAddStatus = SecItemAdd(dic as CFDictionary, nil)
        // 更新
        case errSecItemNotFound: itemAddStatus = SecItemUpdate(dic as CFDictionary,
                                                               [kSecValueData as String: data] as CFDictionary)
        default:
            debugPrint("キーチェーン保存失敗(\(matchingStatus)")
            return
        }
        // 保存・更新ステータス確認
        (itemAddStatus == errSecSuccess) ? debugPrint("キーチェーン正常終了"): debugPrint("キーチェーン保存失敗(error)")
    }
    
    // 取得処理
    static func getKeyChain(key: String) -> String? {

        let dic: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                  kSecAttrGeneric as String: key,
                                  kSecReturnData as String: kCFBooleanTrue ?? ""]

        var data: AnyObject? = nil
        let matchingStatus = withUnsafeMutablePointer(to: &data){
            SecItemCopyMatching(dic as CFDictionary, UnsafeMutablePointer($0))
        }
        guard let getData = data as? Data else {
            debugPrint("キーチェーン取得失敗(Data not founde)")
            return nil
        }
        var result: String? = nil
        if matchingStatus == errSecSuccess {
            result = String(data: getData, encoding: .utf8)
            debugPrint("キーチェーン取得結果: \(result ?? "")")
        } else {
            debugPrint("キーチェーン取得失敗")
        }
        return result
    }
}
