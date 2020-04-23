//
//  SampleObjectAccess.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/22.
//  Copyright © 2020 snowman. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object, Codable {
    
    @objc dynamic var id = 0
    @objc dynamic var created = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct WeatherModel {
    var id = 0
    var created = Date()
    
    var description : String {
        return "\(id), " + created.description
    }
    
    init(object: Weather) {
        id = object.id
        created = object.created
    }
}

class WeatherAccess {
    
    let dao = RealmBaseDao<Weather>()
    
    func load() -> [WeatherModel] {
        let objects = dao.findAll()
        return objects.map { WeatherModel(object: $0) }
    }
    
    func loadRawValueList() -> List<Weather> {
        let result = List<Weather>()
        dao.findAll().forEach { result.append($0) }
        return result
    }
    
    func loadRawValue() -> Array<Weather> {
        var result = Array<Weather>()
        dao.findAll().forEach { result.append($0) }
        return result
    }
    
    func update( date: Date) {
    
        guard let object = dao.findFirst() else {
            return
        }
        
        object.created = date
        
        let _ = dao.update(obj: object)
    }
}
