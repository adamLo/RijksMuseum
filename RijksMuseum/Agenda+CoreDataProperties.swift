//
//  Agenda+CoreDataProperties.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//
//

import Foundation
import CoreData


extension Agenda {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Agenda> {
        return NSFetchRequest<Agenda>(entityName: "Agenda")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var identifier: String?
    @NSManaged public var lang: String?
    @NSManaged public var pageRefTitle: String?
    @NSManaged public var pageRefURL: String?
    @NSManaged public var exposition: Exposition?
    @NSManaged public var expositionType: ExpositionType?
    @NSManaged public var groupType: GroupType?
    @NSManaged public var period: Period?
    @NSManaged public var links: NSSet?

}

// MARK: Generated accessors for links
extension Agenda {

    @objc(addLinksObject:)
    @NSManaged public func addToLinks(_ value: Link)

    @objc(removeLinksObject:)
    @NSManaged public func removeFromLinks(_ value: Link)

    @objc(addLinks:)
    @NSManaged public func addToLinks(_ values: NSSet)

    @objc(removeLinks:)
    @NSManaged public func removeFromLinks(_ values: NSSet)

}
