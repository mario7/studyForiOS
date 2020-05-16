//
//  RealmManagerAccess.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/23.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStudentAccess: Object  {
    
    let dataStudentStr1 = """
    {
    "name": "jane",
    "age": 12,
    "studentId": "1"
    }
    """
    
    let dataStudentStr2 = """
    {
    "name": "tom",
    "age": 12,
    "studentId": "2"
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

    
    /**
     レコード追加(from json)
     */
    func insertRealmManagerFromJson2(_ url: URL) {
       print("\(#function) start")
        let manager = RealmBaseDao<Student2> ()
        do {
            let data = try Data(contentsOf: url)
            let obj = try JSONDecoder().decode(Student2.self, from: data)
            try manager.add(obj: obj)
            let student = manager.findLast()
            print("add => findLast1 after:" + (student?.description ?? "not found")   )
        } catch {
            print("error:\(error)")
        }
        
    }
    
    /**
     レコード追加(from json)
     */
    func insertRealmManagerFromJson1(_ url: URL) {
        print("\(#function) start")
        
        let manager = RealmBaseDao<Student> ()
        do {
            let data = try Data(contentsOf: url)
            let obj = try JSONDecoder().decode(Student.self, from: data)
            try manager.addOrUpdate(obj: obj)
            let student = manager.findLast()
            print("add => findLast2 after:" + (student?.description ?? "not found")   )
        } catch {
            print("error:\(error)")
        }
        
    }
    
    /**
    レコード追加
    */
    func insertRealmManagerForSudent(jsonStr: String) {
        
        print("\(#function) start")
        
        let manager = RealmBaseDao<Student> ()
        do {
            guard let data = jsonStr.data(using: .utf8) else {
                throw NSError(domain: "error data failure", code: -1, userInfo: nil)
            }
            let obj = try JSONDecoder().decode(Student.self, from: data)
            try manager.add(obj: obj)
            let student = manager.findLast()
            print("add => findLast3 after:" + (student?.description ?? "not found")   )
        }  catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error add realm: \(error)")
        }
        print("\(#function) end")
        
    }
    /**
     レコード更新
     */
    func updateRealmManagerForStudent2() {
        print("\(#function) start")
        do {
            let manager = RealmBaseDao<Student> ()
            //1.read
            let student = manager.findFirst()
//            guard let student = result else {
//                print("findFirst result2 not found")
//                throw NSError(domain: "error not found", code: -1, userInfo: nil)
//            }
            print("1.read => findFirst before:" + (student?.description ?? "none")  )
            
            //2.Update
            //manager.update(obj: student)
            try manager.getRealm().write {
                student?.name = "test"
                student?.age = 20
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
     レコード更新
     */
    func updateRealmManagerForStudent() {
        print("\(#function) start")
        do {
            let manager = RealmBaseDao<Student> ()
            //1.read
            let result = manager.findFirst()
            guard let student = result else {
                print("findFirst result2 not found")
                throw NSError(domain: "error not found", code: -1, userInfo: nil)
            }
            print("1.read => findFirst before:" + student.description  )
            
            //2.Update
            manager.update() {
                student.name = "test"
                student.age = 20
                print("2.update => findFirst updateStudent:" + student.description  )
            }
            
            let student3 = manager.findFirst()
            manager.update() {
                student3?.age = 20
            }
            
            
            //print("3.read => findFirst student3:" + (student3?.description ?? "none") )
            
        }  catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error update realm: \(error)")
        }
        print("\(#function) end")
    }
    
    /**
     レコード削除
     */
    func deleteRealmManagerForStudent() {
        print("\(#function) start")
        do {
            let manager = RealmBaseDao<Student> ()
            //try manager.deleteAll()
            
            //            let  obj = Student(name: "test", age: 20)
            
            guard let primaryKey = manager.getPrimaryKey() else {
                throw NSError(domain: "error=> getPrimaryKey", code: -1, userInfo: nil)
            }
            print("1.primaryKey= \(primaryKey) ")
            //1.delete for query
            manager.deleteWithQuery(query: "\(primaryKey) == '2' ")
            
            guard let obj = manager.findFirst() else {
                print("2.delete => data not found")
                return
            }
            print("2.delete => Sucess")
            //2.delete
            manager.delete(obj: obj)
            
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
    func filterRealmManagerForStudent() {
        print("\(#function) start")
        do {
            let manager = RealmBaseDao<Student> ()
            
            guard let primaryKey = manager.getPrimaryKey() else {
                throw NSError(domain: "error=> getPrimaryKey not found", code: -1, userInfo: nil)
            }
            print("1.primaryKey= \(primaryKey) ")
            
            //let primaryKeyValue = "1"
            //let student =  manager.findByPrimaryKey(key: primaryKeyValue)
            
            //print("2.filter => findFirst student:" + (student?.description ?? "none" ))
            
        }  catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error delete realm: \(error)")
        }
        print("\(#function) end")
    }
    
}
