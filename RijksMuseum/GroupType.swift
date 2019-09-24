//
//  GroupType.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import CoreData

extension GroupType {
    
    static let entityName = "GroupType"
    static let identifier = "guid"
    
    struct JSON {
        
        static let friendlyName = "friendlyName"
        static let guid         = "guid"
        static let type         = "type"
    }
    
    class func find(by idvalue: String, in context: NSManagedObjectContext) -> GroupType? {
        
        return find(entity: entityName, by: idvalue, with: identifier, in: context) as? GroupType
    }
    
    class func new(in context: NSManagedObjectContext) -> GroupType {
        
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let item = GroupType(entity: description, insertInto: context)
        return item
    }
    
    func update(with json: JSONObject) {
        
        if let _id = json[JSON.guid] as? String {
            guid = _id
        }
        
        if let _friendlyName = json[JSON.friendlyName] as? String {
            friendlyName = _friendlyName
        }
        
        if let _type = json[JSON.type] as? String {
            type = _type
        }
    }
    
    class func delete(id: String, in context: NSManagedObjectContext) -> Int {
        
        return delete(entity: entityName, identifier: id, with: identifier, in: context)
    }
}
