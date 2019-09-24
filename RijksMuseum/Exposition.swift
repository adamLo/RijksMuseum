//
//  Exposition.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import CoreData

extension Exposition {
    
    static let entityName = "Exposition"
    static let identifier = "identifier"
    
    struct JSON {
        
        static let code                     = "code"
        static let controlType              = "controlType"
        static let description              = "description"
        static let id                       = "id"
        static let maxVisitorsPerGroup      = "maxVisitorsPerGroup"
        static let maxVisitorsPerPeriodWeb  = "maxVisitorsPerPeriodWeb"
        static let name                     = "name"
        static let price                    = "price"
    }
    
    class func find(by idvalue: String, in context: NSManagedObjectContext) -> Exposition? {
        
        return find(entity: entityName, by: idvalue, with: identifier, in: context) as? Exposition
    }
    
    class func new(in context: NSManagedObjectContext) -> Exposition {
        
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let item = Exposition(entity: description, insertInto: context)
        return item
    }
    
    func update(with json: JSONObject) {
        
        if let _id = json[JSON.id] as? String {
            identifier = _id
        }
        
        if let _controlType = json[JSON.controlType] as? Int {
            controlType = Int16(_controlType)
        }
        
        if let _description = json[JSON.description] as? String {
            expositionDescription = _description
        }
        
        if let _maxVisitors = json[JSON.maxVisitorsPerGroup] as? Int {
            maxVisitorsPerGroup = Int64(_maxVisitors)
        }
        
        if let _maxVisitors = json[JSON.maxVisitorsPerPeriodWeb] as? Int {
            maxVisitorsPerPeriodWeb = Int64(_maxVisitors)
        }
        
        if let _name = json[JSON.name] as? String {
            name = _name
        }
        
        if let _code = json[JSON.code] as? String {
            code = _code
        }
        
        if let _price = json[JSON.price] as? JSONObject, let _id = _price[Price.JSON.id] as? String, let context = managedObjectContext {
            
            var price: Price!
            if let __price = Price.find(by: _id, in: context) {
                price = __price
            }
            else {
                price = Price.new(in: context)
            }
            
            price.update(with: _price)
            self.price = price
        }
    }
    
    class func delete(id: String, in context: NSManagedObjectContext) -> Int {
        
        return delete(entity: entityName, identifier: id, with: identifier, in: context)
    }
}
