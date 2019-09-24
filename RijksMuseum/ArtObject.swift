//
//  ArtObject.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import CoreData

/*!
 * @brief ArtObject (collection item) extension to help persistence and parsing
 */
extension ArtObject {
    
    static let entityName = "ArtObject"
    static let identifier = "identifier"
    static let productionPlacesSeparator = ","
    static let maker = "principalOrFirstMaker"
    static let title = "title"
    static let longTitle = "longTitle"
    
    struct JSON {
        
        static let hasImage                 = "hasImage"
        static let headerImage              = "headerImage"
        static let url                      = "url"
        static let id                       = "id"
        static let links                    = "links"
        static let longTitle                = "longTitle"
        static let objectNumber             = "objectNumber"
        static let permitDownload           = "permitDownload"
        static let principalOrFirstMaker    = "principalOrFirstMaker"
        static let productionPlaces         = "productionPlaces"
        static let showImage                = "showImage"
        static let title                    = "title"
        static let webImage                 = "webImage"
    }
    
    /*!
     * @brief Find an ArtObject object with given identifier
     *
     * @param idvalue Identifier to search for
     * @param context Managed object context to search in
     *
     * @return ArtObject if found or nil if not
     */
    class func find(by idvalue: String, in context: NSManagedObjectContext) -> ArtObject? {
        
        return find(entity: entityName, by: idvalue, with: identifier, in: context) as? ArtObject
    }
    
    /*!
     * @brief Creates new ArtObject instance
     *
     * @param context Managed object context to create object in
     *
     * @return New ArtObject instance
     */
    class func new(in context: NSManagedObjectContext) -> ArtObject {
        
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let item = ArtObject(entity: description, insertInto: context)
        return item
    }
    
    /*!
     * @brief Updates ArtObject instance with JSON data
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
        
        if let _hasImage = json[JSON.hasImage] as? Bool {
            hasImage = _hasImage
        }
        else {
            hasImage = false
        }
        
        if let _headerImage = json[JSON.headerImage] as? JSONObject, let _url = _headerImage[JSON.url] as? String {
            headerImagerUrl = _url
        }
        else {
            headerImagerUrl = nil
        }
        
        if let _links = links, let context = managedObjectContext {
            deleteLinkedObjects(objects: _links, in: context)
        }
        if let _links = json[JSON.links] as? JSONObject, let context = managedObjectContext, let __links = Link.process(json: _links, in: context) {
            links = __links
        }
        
        if let _longTitle = json[JSON.longTitle] as? String {
            longTitle = _longTitle
        }
        else {
            longTitle = nil
        }
        
        if let _objectNumber = json[JSON.objectNumber] as? String {
            objectNumber = _objectNumber
        }
        else {
            objectNumber = nil
        }
        
        if let _permitDownload = json[JSON.permitDownload] as? Bool {
            permitDownload = _permitDownload
        }
        else {
            permitDownload = false
        }
        
        if let _principal = json[JSON.principalOrFirstMaker] as? String {
            principalOrFirstMaker = _principal
        }
        else {
            principalOrFirstMaker = nil
        }
        
        if let _productionPlaces = json[JSON.productionPlaces] as? [String] {
            productionPlaces = _productionPlaces.joined(separator: ArtObject.productionPlacesSeparator)
        }
        else {
            productionPlaces = nil
        }
        
        if let _showImage = json[JSON.showImage] as? Bool {
            showImage = _showImage
        }
        else {
            showImage = false
        }
        
        if let _title = json[JSON.title] as? String {
            title = _title
        }
        else {
            title = nil
        }
        
        if let _webImage = json[JSON.webImage] as? JSONObject, let _url = _webImage[JSON.url] as? String {
            webImageUrl = _url
        }
        else {
            webImageUrl = nil
        }
    }
    
    /*!
     * @brief Delete ArtObject instance
     *
     * @param id ArtObject identifier
     * @param context Managed object context to perform deletion in
     *
     * @return True if session removed
     */
    class func delete(id: String, in context: NSManagedObjectContext) -> Int {
        
        return delete(entity: entityName, identifier: id, with: identifier, in: context)
    }
    
    /// Link URL to full size image
    var webImageURL: URL? {
        if let __url = webImageUrl, let _url = URL(string: __url) {
            return _url
        }
        return nil
    }
    
    /// Link URL to small header image
    var headerImageURL: URL? {
        if let __url = headerImagerUrl, let _url = URL(string: __url) {
            return _url
        }
        return nil
    }
    
    /// Link URL to public web page of ArtObject
    var webURL: URL? {
        return Link.url(with: .web, in: links)
    }
}
