//
//  RealmBaseDao.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/22.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import RealmSwift

class RealmBaseDao <T: RealmSwift.Object> {
    let realm: Realm

    init() {
        // Generate a random encryption key
        var key = Data(count: 64)
        _ = key.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        }

        // Open the encrypted Realm file
        let config = Realm.Configuration(encryptionKey: key)
        do {
            realm = try Realm(configuration: config)
        } catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error opening realm: \(error)")
        }
    }

    /**
     * 新規主キー発行
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }

        if let last = realm.objects(T.self).last,
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
        return realm.objects(T.self)
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
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }

    /**
     * 最後のレコードを取得
     */
    func findLast() -> T? {
        return findAll().last
    }
    
    func filter(query: String) -> Results<T> {
        return realm.objects(T.self).filter(query)
    }

    /**
     * レコード追加を取得
     */
    func add(obj :T) {
        do {
            try realm.write {
                realm.add(obj)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }

    /**
    * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
    */
    func update(obj: T, block:(() -> Void)? = nil)  {
        do {
            try realm.write {
                block?()
                realm.add(obj, update: .modified)
            }
            
        } catch let error as NSError {
            print(error.description)
        }
        
    }

    /**
     * レコード削除
     */
    func delete(obj: T) {
        do {
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
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
   
}
