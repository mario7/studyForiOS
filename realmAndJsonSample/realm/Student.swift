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
    @objc dynamic var age = 0
    
    override static func primaryKey() -> String? {
        return "studentId"
    }
    
//    convenience init(name: String, age: Int) {
//        self.init()
//        self.studentId = ""
//        self.name = name
//        self.age = age
//    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Student()
        copy.studentId = studentId
        copy.name = name
        copy.age = age
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
        
    }
    
    func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(studentId, forKey: .studentId)
    try container.encode(name, forKey: .name)
    try container.encode(age, forKey: .age)
    }
}
