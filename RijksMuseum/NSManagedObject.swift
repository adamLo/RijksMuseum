//
//  NSManagedObject.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 14/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import CoreData

/*!
 * @brief Extension to help with Managed Objects
 */
extension NSManagedObject {
    
    /*!
     * @brief Find entities
     *
     * @param name Entity name
     * @param idvalue Identifier value
     * @param fieldName Identifier field name
     * @param context Managed object context to search in
     *
     * @return list of ManagedObjects
     */
    class func findEntities(name: String, by idvalue: String, with fieldName: String, in context: NSManagedObjectContext) -> [Any]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.predicate = NSPredicate(format: "%K = %@", fieldName, idvalue)
        
        do {
            
            let results = try context.fetch(fetchRequest)
            return results
        }
        catch let error {
            print("Error fetching objects: \(error)")
        }
        
        return nil
    }
    
    /*!
     * @brief Find one entity by identifier
     *
     * @param entity Entity name
     * @param idvalue Identifier value
     * @param fieldName Identifier field name
     * @param context Managed object context to search in
     *
     * @return list of ManagedObjects
     */
    class func find(entity: String, by idvalue: String, with fieldName: String, in context: NSManagedObjectContext) -> Any? {
        
        let item = findEntities(name: entity, by: idvalue, with: fieldName, in: context)?.first
        return item
    }
    
    /*!
     * @brief delete entity
     *
     * @param entity Entity name
     * @param idvalue Identifier value
     * @param fieldName Identifier field name
     * @param context Managed object context to search in
     *
     * @return number of deleted objects
     */
    class func delete(entity: String, identifier: String, with fieldName: String, in context: NSManagedObjectContext) -> Int {
        
        var deleted = 0
        
        if let entities = findEntities(name: entity, by: identifier, with: fieldName, in: context) {
            
            for entity in entities {
                
                if let _entity = entity as? NSManagedObject {
                    
                    context.delete(_entity)
                    deleted += 1
                }
            }
        }
        
        return deleted
    }
    
    /*!
     * @brief Delete linked objects to this instance
     *
     * @param objects Set of linked objects
     * @param context Managed object context to perform deletion in
     */
    func deleteLinkedObjects(objects: NSSet, in context: NSManagedObjectContext) {
        
        for _object in objects {
            
            if let __object  = _object as? NSManagedObject {
                
                context.delete(__object)
            }
        }
    }
}
