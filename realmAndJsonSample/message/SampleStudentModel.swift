//
//  studentModel.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/06/14.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation

enum SortOrder
{
    case ascending
    case descending
}

extension Sequence
{
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, order: SortOrder = .ascending) -> [Element] {
        return sorted { a, b in
            switch order
            {
            case .ascending:
                return a[keyPath: keyPath] < b[keyPath: keyPath]
            case .descending:
                return a[keyPath: keyPath] > b[keyPath: keyPath]
            }
        }
    }
}

struct StudentModel {
    var studentId = "0"
    var name = "new"
    var age = "0"

}


class SampleStudentModel {
    
      static func confirmKeyPathType() {
        let studentModel = StudentModel()
        //keyPath 設定
        let nameKeyPath = \StudentModel.name
        
        print(" \(#function) keyPath type: \(String(describing: type(of: nameKeyPath)))")
        // WritableKeyPath<User, String>
        print(" \(#function) keyPath name before: \(studentModel.name)")
        
    }
    
     static func confirmKeyPathSet() {
        var studentModel = StudentModel()
        //keyPath 設定
        let nameKeyPath = \StudentModel.name
        
        print(" \(#function) keyPath name before: \(studentModel.name)")
        
        studentModel[keyPath: nameKeyPath ] = "updated"
        
        print(" \(#function) keyPath name after: \(studentModel.name)")
        
    }
    
     static func keyPathSortWithAge() {

        let array =  [StudentModel(studentId: "003", name: "3", age: "10"),
        StudentModel(studentId: "002", name: "1", age: "15"),
        StudentModel(studentId: "001", name: "2", age: "20")]

        let ageKeyPath = \StudentModel.age
        let results = array.sorted {
            $0[keyPath: ageKeyPath] > $1[keyPath: ageKeyPath]
        }
         print(" \(#function) 1.sorted result: \(results) ")

        let results2 = array.sorted{ $0.age > $1.age }
        //array.sort{ $0.age > $1.age }

        //let results2 = array.sorted(by: \StudentModel.age)
         print(" \(#function) 2.sorted result: \(results2) ")

        let results3 = array.sorted(by: \StudentModel.studentId)

         print(" \(#function) 3.sorted result: \(results3) ")
    }
}
