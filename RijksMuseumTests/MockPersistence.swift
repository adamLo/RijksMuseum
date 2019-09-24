//
//  MockPersistence.swift
//  RijksMuseumTests
//
//  Created by Adam Lovastyik on 13/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

class MockPersistence: PersistenceProtocol {
    
    let insertedIds: [String]?
    let updatedIds: [String]?
    let deletedIds: [String]?
    
    init(expectedInserts: [String]? = nil, expectedUpdates: [String]? = nil, expectedDeletions: [String]? = nil) {
        
        self.insertedIds = expectedInserts
        self.updatedIds = expectedUpdates
        self.deletedIds = expectedDeletions
    }
    
    func process(agendas: [JSONObject]) -> (inserted: Int, updated: Int, error: Error?) {
        
        var inserts = 0
        var updates = 0
        
        for object in agendas {
            
            if let _id = object[Agenda.JSON.id] as? String {
                
                if let _inserted = insertedIds, _inserted.contains(_id) {
                    inserts += 1
                }
                else if let _updated = updatedIds, _updated.contains(_id) {
                    updates += 1
                }
            }
        }
        
        return (inserted: inserts, updated: updates, error: nil)
    }
    
    func delete(itemId: String) -> (deleted: Int, error: Error?) {
        
        var deleted = 0
        if let _deleted = deletedIds, _deleted.contains(itemId) {
            deleted += 1
        }
        
        return (deleted: deleted, error: nil)
    }
    
    func process(artObjects: [JSONObject]) -> (inserted: Int, updated: Int, error: Error?) {
        
        var inserts = 0
        var updates = 0
        
        for object in artObjects {
            
            if let _id = object[ArtObject.JSON.id] as? String {
                
                if let _inserted = insertedIds, _inserted.contains(_id) {
                    inserts += 1
                }
                else if let _updated = updatedIds, _updated.contains(_id) {
                    updates += 1
                }
            }
        }
        
        return (inserted: inserts, updated: updates, error: nil)
    }
}
