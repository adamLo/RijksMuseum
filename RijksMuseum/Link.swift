//
//  Link.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import CoreData

extension Link {
    
    static let entityName = "Link"
    
    enum LinkType: String, CaseIterable {
        case availability, web, selfLink = "self"
    }
    
    class func new(in context: NSManagedObjectContext) -> Link {
        
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let item = Link(entity: description, insertInto: context)
        return item
    }
    
    static func process(json: JSONObject, in contect: NSManagedObjectContext) -> NSSet? {
        
        guard !json.isEmpty else {return nil}
        
        var links = [Link]()
        
        for type in LinkType.allCases {
            
            if let value = json[type.rawValue] as? String {
                
                let link = Link.new(in: contect)
                link.type = type.rawValue
                link.url = value
                links.append(link)
            }
        }
        
        return links.isEmpty ? nil : NSSet(array: links)
    }
    
    static func url(with type: LinkType, in links: NSSet?) -> URL? {
        
        if let _links = links?.allObjects as? [Link] {
            
            if let _link = _links.filter({ (link) -> Bool in
                
                if let __type = link.type, let _type = Link.LinkType(rawValue: __type), _type == type {
                    return true
                }
                return false
                
            }).first, let _url = _link.url, let url = URL(string: _url) {
                return url
            }
        }
        
        return nil
    }
}
