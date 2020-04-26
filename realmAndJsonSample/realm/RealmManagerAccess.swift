//
//  RealmMangerAccess.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/23.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManagerAccess: Object  {
    
let dataStudentStr = """
{
"name": "jane",
"age": 12,
"studentId": "1"
}
"""
    
    let dataStudentDetailStr = """
{
"name": "jane",
"age": 12,
"song": "",
"date": "2020-04-01 12:23:59",
"studentId": "1"
}
"""
    
    func accessRealmManger() {
        
        insertRealmMangerForSudent()
        updateRealmMangerForStudent()
        filterRealmMangerForStudent()
        deleteRealmMangerForStudent()
        
    }
    
    /**
     レコード追加
     */
    func insertRealmMangerForSudent() {
        
        print("\(#function) start")
        
        let manager = RealmManger<Student> ()
        do {
            guard let data = dataStudentStr.data(using: .utf8) else {
                throw NSError(domain: "error data failure", code: -1, userInfo: nil)
            }
            let obj = try JSONDecoder().decode(Student.self, from: data)
            try manager.add(obj: obj)
            let student = manager.findFirst()
            print("add => findFirst after:" + (student?.description ?? "not found")   )
        }  catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error add realm: \(error)")
        }
        print("\(#function) end")
        
    }
    /**
     レコード更新
     */
    func updateRealmMangerForStudent() {
        print("\(#function) start")
        do {
            let manager = RealmManger<Student> ()
            //1.read
            let result = manager.findFirst()
            guard let student = result else {
                print("findFirst result2 not found")
                throw NSError(domain: "error not found", code: -1, userInfo: nil)
            }
            print("1.read => findFirst before:" + student.description  )
            
            //2.Update
            try manager.update(obj: student) {
                student.name = "test"
                student.age = 20
                print("2.update => findFirst updateStudent:" + student.description  )
            }
            
            let student3 = manager.findFirst()
            print("3.read => findFirst student3:" + (student3?.description ?? "none") )
            
        }  catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error update realm: \(error)")
        }
        print("\(#function) end")
    }
    
    /**
     レコード削除
     */
    func deleteRealmMangerForStudent() {
        print("\(#function) start")
        do {
            let manager = RealmManger<Student> ()
            //try manager.deleteAll()
            
//            let  obj = Student(name: "test", age: 20)
            
            guard let primaryKey = manager.getPrimaryKey() else {
                throw NSError(domain: "error=> getPrimaryKey", code: -1, userInfo: nil)
            }
            print("1.primaryKey= \(primaryKey) ")
            //1.delete for query
            try manager.deleteWithQuery(query: "\(primaryKey) == '1' ")
            
            guard let obj = manager.findFirst() else {
                print("2.delete => data not found")
                return
            }
            
            //2.delete
            try manager.delete(obj: obj)
            
            let student = manager.findFirst()
            print("3.delete => findFirst student:" + (student?.description ?? "none") )
            
        }  catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error delete realm: \(error)")
        }
        print("\(#function) end")
    }
    
    /**
         レコード検索
         */
        func filterRealmMangerForStudent() {
            print("\(#function) start")
            do {
                let manager = RealmManger<Student> ()
                
                guard let primaryKey = manager.getPrimaryKey() else {
                    throw NSError(domain: "error=> getPrimaryKey not found", code: -1, userInfo: nil)
                }
                print("1.primaryKey= \(primaryKey) ")
                
                let primaryKeyValue = "1"
                let student =  manager.findByPrimaryKey(key: primaryKeyValue)
                
                print("2.filter => findFirst student:" + (student?.description ?? "none" ))
                
            }  catch let error as NSError {
                // If the encryption key is wrong, `error` will say that it's an invalid database
                fatalError("Error delete realm: \(error)")
            }
            print("\(#function) end")
        }
    
}
