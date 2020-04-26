//
//  RealmManager.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/22.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManger <T: RealmSwift.Object> {
    private let  realm = try! Realm()
    
    /**
     新規主キー取得
     条件：primaryKey設定された場合のみ
     - returns:
     */
    func getIncreasedPrimaryKey() -> Int? {
        guard let key = T.primaryKey() else {
            print("primaryKey 未設定")
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
     全件取得
     　- returns: Results<T>
     */
    func findAll() -> Results<T> {
        return realm.objects(T.self)
    }
    
    /**
     1件目のみ取得
     - returns: T?
     */
    func findFirst() -> T? {
        return findAll().first
    }
    
    /**
     特定キーのレコードの取得
     - parameter : Any
     - returns: T?
     */
    func findByPrimaryKey(key: Any) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    /**
     最後のレコードの取得
     - returns: T?
     */
    func findLast() -> T? {
        return findAll().last
    }
    
    /**
     クエリでレコードの取得
     - parameter : Any
     - returns: Results<T>
     */
    func filter(query: String) -> Results<T> {
        print("\(#function), query= \(query) ")
        
        if query.isEmpty {
            return realm.objects(T.self)
        }
        return realm.objects(T.self).filter(query)
    }
    
    /**
     レコードの追加
     - parameter :  T
     */
    func add(obj :T) throws {
        
        try realm.write {
            realm.add(obj, update: .modified)
        }
    }
    
    /**
     レコードの更新
     　 　 条件： primaryKey()が実装されている時のみ有効
     - parameter :  T
     - parameter :  (() -> Void)?
     */
    func update(obj: T,_ block:(() -> Void)? = nil) throws {
        
        try realm.write {
            block?()
            realm.add(obj, update: .modified)
        }
    }
    
    /**
     * レコードの削除
     */
    func delete(obj: T) throws {
        
        try realm.write {
            realm.delete(obj)
        }
    }
    
    /**
     * 全レコードの削除
     */
    func deleteAll() throws {
        let objs = realm.objects(T.self)
        
        try realm.write {
            realm.delete(objs)
        }
        
    }
    
    func getRealm() -> Realm {
       return realm
    }
}
