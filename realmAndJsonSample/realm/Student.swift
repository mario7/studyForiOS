//
//  Student.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/23.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import RealmSwift


class Student2: Object, Codable {
    @objc dynamic var studentId = ""
    @objc dynamic var age = 0
    
//    override public static func primaryKey() -> String? {
//        return "customPrimaryKey"
//        return String(format: "studentId_age")
//    }
    
    convenience init(studentId: String, age: Int) {
        self.init()
        self.studentId = studentId
        self.age = age

    }
    
    private enum CodingKeys: String, CodingKey {
       case studentId
       case age
    }
    
    required convenience public init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)

    studentId = try container.decode(String.self, forKey: .studentId)
    age = try container.decode(Int.self, forKey: .age)
 
    }
    
    func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(studentId, forKey: .studentId)
    try container.encode(age, forKey: .age)
    }
    
}

class Student: Object, Codable, NSCopying {
    @objc dynamic var studentId = ""
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    @objc dynamic var customPrimaryKey = ""
    
    override public static func primaryKey() -> String? {
        return "customPrimaryKey"
    }
    
    convenience init(studentId: String, age: Int) {
        self.init()
        self.studentId = studentId
        self.name = name
        self.age = age
        self.customPrimaryKey =  String(format: "%@_%d ", studentId,age)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Student()
        copy.studentId = studentId
        copy.name = name
        copy.age = age
        copy.customPrimaryKey = customPrimaryKey
        return copy
    }
    
    private enum CodingKeys: String, CodingKey {
       case studentId
       case name
       case age
    }
    
    required convenience public init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)

    studentId = try container.decode(String.self, forKey: .studentId)
    name = try container.decode(String.self, forKey: .name)
    age = try container.decode(Int.self, forKey: .age)
    customPrimaryKey =  String(format: "%@_%d ", studentId,age)
    }
    
    func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(studentId, forKey: .studentId)
    try container.encode(name, forKey: .name)
    try container.encode(age, forKey: .age)
    }
}
