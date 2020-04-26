//
//  Student.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/23.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import RealmSwift

class Student: Object, Codable, NSCopying {
    
    @objc dynamic var studentId = ""
    @objc dynamic var name = ""
    @objc dynamic var age = 11
    
    override static func primaryKey() -> String? {
        return "studentId"
    }
    
    convenience init(name: String, age: Int) {
        self.init()
        self.studentId = ""
        self.name = name
        self.age = age
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Student()
        copy.studentId = studentId
        copy.name = name
        copy.age = age
        return copy
    }
}
