//
//  ArtObject+CoreDataProperties.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//
//

import Foundation
import CoreData


extension ArtObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtObject> {
        return NSFetchRequest<ArtObject>(entityName: "ArtObject")
    }

    @NSManaged public var hasImage: Bool
    @NSManaged public var headerImagerUrl: String?
    @NSManaged public var identifier: String?
    @NSManaged public var longTitle: String?
    @NSManaged public var objectNumber: String?
    @NSManaged public var principalOrFirstMaker: String?
    @NSManaged public var title: String?
    @NSManaged public var webImageUrl: String?
    @NSManaged public var permitDownload: Bool
    @NSManaged public var showImage: Bool
    @NSManaged public var productionPlaces: String?
    @NSManaged public var links: NSSet?

}

// MARK: Generated accessors for links
extension ArtObject {

    @objc(addLinksObject:)
    @NSManaged public func addToLinks(_ value: Link)

    @objc(removeLinksObject:)
    @NSManaged public func removeFromLinks(_ value: Link)

    @objc(addLinks:)
    @NSManaged public func addToLinks(_ values: NSSet)

    @objc(removeLinks:)
    @NSManaged public func removeFromLinks(_ values: NSSet)

}
