//
//  Persistence.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 10/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import CoreData

/*!
 * @brief Singleton class to help persistence both for in-memory (testing) and Core Data
 */
class Persistence: PersistenceProtocol {
    
    /// Shared instance
    static let shared = Persistence()
    
    private let modelName       = "RijksMuseum"
    private let databaseName    = "RijksMuseum"
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveContextDidSaveNotification(notification:)), name:NSNotification.Name.NSManagedObjectContextDidSave, object:nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    // MARK: - Setup model and database
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.decos.IMC" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last!
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    /*!
     * @brief Sets up Core Data persistent store
     */
    func setupCoreDataPersistentStore() {
        
        guard persistentStoreCoordinator == nil else {abort()}
        
        let coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.databaseName + ".sqlite")
        
        #if DEBUG
        print("*** CoreData \(url)")
        #endif
        
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true
                ])
        }
        catch let error {
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(error)")
            abort()
        }
        
        persistentStoreCoordinator = coordinator
    }
    
    /*!
     * @brief Sets up in-memory cache (used for testing)
     */
    func setupInMemoryPersistentStore() {
        
        guard persistentStoreCoordinator == nil else {abort()}
        
        let coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator!.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true
                ])
            
        }
        catch let error {
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(error)")
            abort()
        }
        
        persistentStoreCoordinator = coordinator
    }
    
    // MARK: - Managed object contexts
    
    /// Main context
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        
        if let coordinator = self.persistentStoreCoordinator {
            
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            context.undoManager = nil
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            return context
        }
        
        return nil
    }()
    
    /*!
     * @brief Creates a new managed object context to handle operations
     *
     * @return New managed object context
     */
    func createNewManagedObjectContext() -> NSManagedObjectContext {
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        context.undoManager = nil
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return context
    }
    
    @objc func didReceiveContextDidSaveNotification(notification: Notification) {
        
        let sender = notification.object as! NSManagedObjectContext
        
        if sender != self.managedObjectContext {
            
            self.managedObjectContext?.perform {
                
                DispatchQueue.main.async {
                    
                    self.managedObjectContext?.mergeChanges(fromContextDidSave: notification)
                }
            }
        }
    }
    
    // MARK: - PersisenceProtocol {
    
    /// Prooesses Agenda objects
    func process(agendas: [JSONObject]) -> (inserted: Int, updated: Int, error: Error?) {
        
        do {
            
            var inserted = 0
            var updated = 0
            
            let context = Persistence.shared.createNewManagedObjectContext()
            context.performAndWait {
                
                for jsonObject in agendas {
                    
                    if let identifier = jsonObject[Agenda.JSON.id] as? String, !identifier.isEmpty {

                        var agenda: Agenda!
                        if let _agenda = Agenda.find(by: identifier, in: context) {
                            agenda = _agenda
                            updated += 1
                        }
                        else {
                            agenda = Agenda.new(in: context)
                            inserted += 1
                        }
                        agenda.update(with: jsonObject)
                    }
                }
            }
            
            try context.save()
            
            return(inserted: inserted, updated: updated, error: nil)
        }
        catch let error {
            
            return (inserted: 0, updated: 0, error: error)
        }
    }
    
    /// Processes Collection items
    func process(artObjects: [JSONObject]) -> (inserted: Int, updated: Int, error: Error?) {
        
        do {
            
            var inserted = 0
            var updated = 0
            
            let context = Persistence.shared.createNewManagedObjectContext()
            context.performAndWait {
                
                for jsonObject in artObjects {
                    
                    if let identifier = jsonObject[ArtObject.JSON.id] as? String, !identifier.isEmpty {
                        
                        var artObject: ArtObject!
                        if let _artObject = ArtObject.find(by: identifier, in: context) {
                            artObject = _artObject
                            updated += 1
                        }
                        else {
                            artObject = ArtObject.new(in: context)
                            inserted += 1
                        }
                        artObject.update(with: jsonObject)
                    }
                }
            }
            
            try context.save()
            
            return(inserted: inserted, updated: updated, error: nil)
        }
        catch let error {
            
            return (inserted: 0, updated: 0, error: error)
        }
    }
}
