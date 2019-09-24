//
//  Price.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import CoreData

extension Price {
    
    static let entityName = "Price"
    static let identifier = "identifier"
    
    struct JSON {
        
        static let amount           = "amount"
        static let calculationType  = "calculationType"
        static let id               = "id"
    }
    
    class func find(by idvalue: String, in context: NSManagedObjectContext) -> Price? {
        
        return find(entity: entityName, by: idvalue, with: identifier, in: context) as? Price
    }
    
    class func new(in context: NSManagedObjectContext) -> Price {
        
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let item = Price(entity: description, insertInto: context)
        return item
    }
    
    func update(with json: JSONObject) {
        
        if let _id = json[JSON.id] as? String {
            identifier = _id
        }
        
        if let _calculationType = json[JSON.calculationType] as? Int {
            calculationType = Int64(_calculationType)
        }
        
        if let _amount = json[JSON.amount] as? Double {
            amount = _amount
        }
    }
    
    class func delete(id: String, in context: NSManagedObjectContext) -> Int {
        
        return delete(entity: entityName, identifier: id, with: identifier, in: context)
    }
}
