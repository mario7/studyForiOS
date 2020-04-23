//
//  ViewController.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/07.
//  Copyright © 2020 snowman. All rights reserved.
//

import UIKit
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

class StudentDetail: Object, Codable {
    
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var birthday : Date?
    @objc dynamic var song : String?
    let age = RealmOptional<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case birthday = "date"
        case song
        case age
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        //birthday = try container.decode(Int.self, forKey: .birthday)
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:ssZZZZ"
        let birthdayStr = try container.decode(String.self, forKey: .birthday)
        birthday = getDateFormatter().date(from: birthdayStr)
        
        
        song = try container.decode(String.self, forKey: .song)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy : CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:ssZZZZ"
        guard  let date = birthday else {
            return
        }
        let birthdayStr = getDateFormatter().string(from: date)
        try container.encode(birthdayStr, forKey: .birthday)
        
        try container.encode(song, forKey: .song)
        
    }
    
    func getDateFormatter() ->DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        insertRealmMangerForSudent()
        updateRealmMangerForStudent()
        deleteRealmMangerForStudent()
        
        //        insertRealmFromStudentJson()
        //        loadRealmFromStudentJson()
        //
        //        insertRealmFromStudentDetailJson()
        //        loadRealmFromStudentDetailJson()
    }
    
    func checkScheme () {
        #if DEBUG
        testLabel.text = "debug"
        #elseif STAGING
        testLabel.text = "staging"
        #else
        testLabel.text = "release"
        #endif
        
        
        let configJson = Bundle.main.object(forInfoDictionaryKey: "kUserConfigureJson") as! String
        
        print(configJson.description )
    }
    
    func insertRealmFromStudentJson() {
        
        let realm = try! Realm()
        guard let data = dataStudentStr.data(using: .utf8) else {
            return
        }
        
        let obj = try! JSONDecoder().decode(Student.self, from: data)
        
        try! realm.write {
            realm.add(obj, update: .modified)
        }
    }
    
    func loadRealmFromStudentJson() {
        let realm = try! Realm()
        
        guard let obj = realm.objects(Student.self).first else {
            return
        }
        
        
        let encoder = JSONEncoder()
        
        let data = try! encoder.encode(obj)
        
        let jsonStr = String(data: data, encoding: .utf8)
        
        
        print(obj.description as Any)
        print(jsonStr?.description as Any)
    }
    
    func insertRealmFromStudentDetailJson() {
        
        let realm = try! Realm()
        guard let data = dataStudentDetailStr.data(using: .utf8) else {
            return
        }
        
        let obj = try! JSONDecoder().decode(StudentDetail.self, from: data)
        
        
        try! realm.write {
            realm.add(obj, update: .modified)
        }
    }
    
    func loadRealmFromStudentDetailJson() {
        let realm = try! Realm()
        
        guard let obj = realm.objects(StudentDetail.self).first else {
            return
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(obj)
        
        let jsonStr = String(data: data, encoding: .utf8)
        
        
        print(obj.description as Any)
        print(jsonStr?.description as Any)
    }
    
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

