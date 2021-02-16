//
//  RealmBaseDao.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/22.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import RealmSwift
//import CryptoKit

class RealmBaseDao <T: RealmSwift.Object> {
    //private let realm = try! Realm()

    // Open the encrypted Realm file
    private var encryptedRealm: Realm {
//        do {
//            if let data = UUID().uuidString.data(using: .utf8) {
//                let config = Realm.Configuration(encryptionKey: SHA256.hash(data: data).data)
//                return try Realm(configuration: config)
//            }
//        } catch let error as NSError {
//            // If the encryption key is wrong, `error` will say that it's an invalid database
//            fatalError("Error opening realm: \(error)")
//        }
        return try! Realm()
    }
    
    init() {
//        // Generate a random encryption key
//        var key = Data(count: 64)
//        _ = key.withUnsafeMutableBytes { bytes in
//            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
//        }
//
//        // Open the encrypted Realm file
//        let config = Realm.Configuration(encryptionKey: key)
//        do {
//            realm = try Realm(configuration: config)
//        } catch let error as NSError {
//            // If the encryption key is wrong, `error` will say that it's an invalid database
//            fatalError("Error opening realm: \(error)")
//        }
    }

    /**
     * 新規主キー発行
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }

        if let last = encryptedRealm.objects(T.self).last,
            let lastId = last[key] as? Int {
            return lastId + 1
        } else {
            return 1
        }
    }

    /**
     * 全件取得
     */
    func findAll() -> Results<T> {
        return encryptedRealm.objects(T.self)
    }

    /**
     * 1件目のみ取得
     */
    func findFirst() -> T? {
        return findAll().first
    }

    /**
     * 指定キーのレコードを取得
     */
    func findFirst(key: AnyObject) -> T? {
        return encryptedRealm.object(ofType: T.self, forPrimaryKey: key)
    }

    /**
     * 最後のレコードを取得
     */
    func findLast() -> T? {
        return findAll().last
    }
    
    func filter(query: String) -> Results<T> {
        return encryptedRealm.objects(T.self).filter(query)
    }

    /**
     * レコードの追加
     */
    func add(obj :T) throws {
        let realm = encryptedRealm
        try realm.write {
            //realm.add(obj, update: .modified)
            realm.add(obj)
        }
        
    }
    
    /**
     * レコードの追加／更新
     */
    func addOrUpdate(obj :T) throws {
        let realm = encryptedRealm
        try realm.write {
            realm.add(obj, update: .modified)
        }
    }

    func updateOnly(block: @escaping () -> Void ) throws {
        try encryptedRealm.write(block)
    }
    /**
    * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
    */
    func update( block:@escaping () -> Void)  {
        do {
            try encryptedRealm.write (block)
            
        } catch let error as NSError {
            print(error.description)
        }
        
    }

    /**
     * レコード削除
     */
    func delete(obj: T) {
        do {
            let realm = encryptedRealm
            try realm.write {
                realm.delete(obj)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }

    /**
     * レコード全削除
     */
    func deleteAll() {
        let realm = encryptedRealm
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func deleteWithQuery(query: String) {
        let realm = encryptedRealm
        let objs = realm.objects(T.self).filter(query)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error as NSError {
            print(error.description)
        }
        
    }
    
    func getPrimaryKey() -> String?{
        return T.primaryKey()
    }
    
    func getRealm() -> Realm {
        return encryptedRealm
    }
}
