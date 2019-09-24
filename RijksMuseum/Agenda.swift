//
//  Agenda.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import CoreData

/*!
 * @brief Agenda object extension to help persistence and parsing
 */
extension Agenda {
    
    static let entityName   = "Agenda"
    static let identifier   = "identifier"
    static let date         = "date"
    
    struct JSON {
        
        static let date             = "date"
        static let exposition       = "exposition"
        static let expositionType   = "expositionType"
        static let groupType        = "groupType"
        static let id               = "id"
        static let lang             = "lang"
        static let links            = "links"
        static let pageRef          = "pageRef"
        static let period           = "period"
        
        static let pageRefTitle     = "title"
        static let pageRefUrl       = "url"
    }
    
    /*!
     * @brief Find an Agenda object with given identifier
     *
     * @param idvalue Identifier to search for
     * @param context Managed object context to search in
     *
     * @return Agenda if found or nil if not
     */
    class func find(by idvalue: String, in context: NSManagedObjectContext) -> Agenda? {
        
        return find(entity: entityName, by: idvalue, with: identifier, in: context) as? Agenda
    }
    
    /*!
     * @brief Creates new Agenda instance
     *
     * @param context Managed object context to create object in
     *
     * @return New Agenda instance
     */
    class func new(in context: NSManagedObjectContext) -> Agenda {
        
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let item = Agenda(entity: description, insertInto: context)
        return item
    }
    
    /*!
     * @brief Updates Agenda instance with JSON data
     *
     * @param json JSON object
     */
    func update(with json: JSONObject) {

        if let _id = json[JSON.id] as? String {
            identifier = _id
        }
        else {
            identifier = nil
        }
        
        date = nil
        if let _dateText = json[JSON.date] as? String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Network.Configuration.longDateFormat
            
            if let _date = dateFormatter.date(from: _dateText) {
                date = NSDate(timeIntervalSince1970: _date.timeIntervalSince1970)
            }
        }
        
        if let _lang = json[JSON.lang] as? String {
            lang = _lang
        }
        else {
            lang = nil
        }
        
        if let _pageRef = json[JSON.pageRef] as? JSONObject {
            
            if let _title = _pageRef[JSON.pageRefTitle] as? String {
                pageRefTitle = _title
            }
            else {
                pageRefTitle = nil
            }
            
            if let _url = _pageRef[JSON.pageRefUrl] as? String {
                pageRefURL = _url
            }
            else {
                pageRefURL = nil
            }
        }
        else {
            pageRefTitle = nil
            pageRefURL = nil
        }
        
        if let _exposition = json[JSON.exposition] as? JSONObject, let _id = _exposition[Exposition.JSON.id] as? String, let context = managedObjectContext {
            
            var exposition: Exposition!
            if let __exposition = Exposition.find(by: _id, in: context) {
                exposition = __exposition
            }
            else {
                exposition = Exposition.new(in: context)
            }
            exposition.update(with: _exposition)
            self.exposition = exposition
        }
        else {
            exposition = nil
        }
        
        if let _expositionType = json[JSON.expositionType] as? JSONObject, let _id = _expositionType[ExpositionType.JSON.guid] as? String, let context = managedObjectContext {
            
            var expositionType: ExpositionType!
            if let __expositionType = ExpositionType.find(by: _id, in: context) {
                expositionType = __expositionType
            }
            else {
                expositionType = ExpositionType.new(in: context)
            }
            expositionType.update(with: _expositionType)
            self.expositionType = expositionType
        }
        else {
            expositionType = nil
        }
        
        if let _groupType = json[JSON.groupType] as? JSONObject, let _id = _groupType[GroupType.JSON.guid] as? String, let context = managedObjectContext {
            
            var groupType: GroupType!
            if let __groupType = GroupType.find(by: _id, in: context) {
                groupType = __groupType
            }
            else {
                groupType = GroupType.new(in: context)
            }
            groupType.update(with: _groupType)
            self.groupType = groupType
        }
        else {
            groupType = nil
        }
        
        if let _period = json[JSON.period] as? JSONObject, let _id = _period[Period.JSON.id] as? String, let context = managedObjectContext {
            
            var period: Period!
            if let __period = Period.find(by: _id, in: context) {
                period = __period
            }
            else {
                period = Period.new(in: context)
            }
            period.update(with: _period)
            self.period = period
        }
        else {
            period = nil
        }
        
        if let _links = links, let context = managedObjectContext {
            deleteLinkedObjects(objects: _links, in: context)
        }
        if let _links = json[JSON.links] as? JSONObject, let context = managedObjectContext, let __links = Link.process(json: _links, in: context) {
            links = __links
        }
    }
    
    /*!
     * @brief Delete Agenda instance
     *
     * @param id Agenda identifier
     * @param context Managed object context to perform deletion in
     *
     * @return True if session removed
     */
    class func delete(id: String, in context: NSManagedObjectContext) -> Int {
        
        return delete(entity: entityName, identifier: id, with: identifier, in: context)
    }
    
    /// Returns public link url to Agenda on web
    var webURL: URL? {
        return Link.url(with: .web, in: links)
    }
}
