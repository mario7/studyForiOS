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
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Student()
        copy.id = id
        copy.name = name
        copy.age = age
        return copy
    }
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var age = 11
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: String, age: Int) {
        self.init()
        self.id = 0
        self.name = name
        self.age = age
    }
}
