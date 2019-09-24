//
//  Period.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import CoreData

extension Period {
    
    static let entityName = "Period"
    static let identifier = "identifier"
    
    struct JSON {
        
        static let code         = "code"
        static let current      = "current"
        static let endDate      = "endDate"
        static let id           = "id"
        static let maximum      = "maximum"
        static let remaining    = "remaining"
        static let startDate    = "startDate"
        static let text         = "text"
    }
    
    class func find(by idvalue: String, in context: NSManagedObjectContext) -> Period? {
        
        return find(entity: entityName, by: idvalue, with: identifier, in: context) as? Period
    }
    
    class func new(in context: NSManagedObjectContext) -> Period {
        
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let item = Period(entity: description, insertInto: context)
        return item
    }
    
    func update(with json: JSONObject) {
        
        if let _id = json[JSON.id] as? String {
            identifier = _id
        }
        else {
            identifier = nil
        }
        
        if let _code = json[JSON.code] as? String {
            code = _code
        }
        else {
            code = nil
        }
        
        if let _current = json[JSON.current] as? Int {
            current = Int64(_current)
        }
        else {
            current = 0
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Network.Configuration.longDateFormat
        
        if let _dateText = json[JSON.startDate] as? String, let _date = dateFormatter.date(from: _dateText) {
            startDate = NSDate(timeIntervalSince1970: _date.timeIntervalSince1970)
        }
        else {
            startDate = nil
        }
        
        if let _dateText = json[JSON.endDate] as? String, let _date = dateFormatter.date(from: _dateText) {
            endDate = NSDate(timeIntervalSince1970: _date.timeIntervalSince1970)
        }
        else {
            endDate = nil
        }
        
        if let _maximum = json[JSON.maximum] as? Int {
            maximum = Int64(_maximum)
        }
        else {
            maximum = 0
        }
        
        if let _remaining = json[JSON.remaining] as? Int {
            remaining = Int64(_remaining)
        }
        else {
            remaining = 0
        }
        
        if let _text = json[JSON.text] as? String {
            text = _text
        }
        else {
            text = nil
        }
    }
    
    class func delete(id: String, in context: NSManagedObjectContext) -> Int {
        
        return delete(entity: entityName, identifier: id, with: identifier, in: context)
    }
}
