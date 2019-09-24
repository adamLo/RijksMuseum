//
//  Period+CoreDataProperties.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//
//

import Foundation
import CoreData


extension Period {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Period> {
        return NSFetchRequest<Period>(entityName: "Period")
    }

    @NSManaged public var code: String?
    @NSManaged public var current: Int64
    @NSManaged public var endDate: NSDate?
    @NSManaged public var identifier: String?
    @NSManaged public var maximum: Int64
    @NSManaged public var remaining: Int64
    @NSManaged public var startDate: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var agendas: NSSet?

}

// MARK: Generated accessors for agendas
extension Period {

    @objc(addAgendasObject:)
    @NSManaged public func addToAgendas(_ value: Agenda)

    @objc(removeAgendasObject:)
    @NSManaged public func removeFromAgendas(_ value: Agenda)

    @objc(addAgendas:)
    @NSManaged public func addToAgendas(_ values: NSSet)

    @objc(removeAgendas:)
    @NSManaged public func removeFromAgendas(_ values: NSSet)

}
