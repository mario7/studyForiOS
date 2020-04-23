//
//  RealmMangerAccess.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/23.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMangerAccess: Object  {
    
    let dataStudentStr = """
{
"name": "jane",
"age": 12,
"id": 0
}
"""
    
    let dataStudentDetailStr = """
{
"name": "jane",
"age": 12,
"song": "",
"date": "2020-04-01 12:23:59",
"id": 1
}
"""
    
    func accessRealmManger() {
        
        insertRealmMangerForSudent()
        updateRealmMangerForStudent()
        deleteRealmMangerForStudent()
        
    }
    
    /**
     レコード追加
     */
    func insertRealmMangerForSudent() {
        
        guard let data = dataStudentStr.data(using: .utf8) else {
            return
        }
        
        let manager = RealmManger<Student> ()
        
        do {
            let obj = try! JSONDecoder().decode(Student.self, from: data)
            
            try manager.deleteAll()
            //ADD
            try manager.add(obj: obj)
            
            let result = manager.findFirst()
            
            guard let student = result else {
                print("findFirst result1 not found")
                throw NSError(domain: "errorメッセージ", code: -1, userInfo: nil)
            }
            print("add => findFirst after:" + student.description  )
            
        }  catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error add realm: \(error)")
        }
        
    }
    /**
     レコード更新
     */
    func updateRealmMangerForStudent() {
        do {
            let manager = RealmManger<Student> ()
            //1.read
            let result = manager.findFirst()
            guard let student = result else {
                print("findFirst result2 not found")
                throw NSError(domain: "errorメッセージ", code: -1, userInfo: nil)
            }
            print("1.read => findFirst before:" + student.description  )
            
            //2.update
            let realm = try! Realm()
            try realm.write {
                student.age = 19
            }
            print("2.update => findFirst after1:" + student.description  )
            let student2 = manager.findFirst()
            print("3.read => findFirst student2:" + (student2?.description ?? "none") )
            
            //3.Update
            let  updateStudent = Student(name: "test", age: 20)
            print("4.update => findFirst updateStudent:" + updateStudent.description  )
            try manager.update(obj: updateStudent) {
                let student3 = manager.findFirst()
                print("5.read => findFirst student3:" + (student3?.description ?? "none") )
            }
        }  catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error update realm: \(error)")
        }
    }
    
    /**
     レコード削除
     */
    func deleteRealmMangerForStudent() {
        do {
            let manager = RealmManger<Student> ()
            //try manager.deleteAll()
            
            //let  deleteStudent = Student(name: "test", age: 20)
            guard let deleteStudent = manager.findFirst() else {
                print("delete => data not found")
                return
            }
            
            try manager.delete(obj: deleteStudent)
            
            let student = manager.findFirst()
            print("delete => findFirst student:" + (student?.description ?? "none") )
            
        }  catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error delete realm: \(error)")
        }
    }
    
}
