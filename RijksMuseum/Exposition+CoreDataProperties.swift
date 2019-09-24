//
//  Exposition+CoreDataProperties.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//
//

import Foundation
import CoreData


extension Exposition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exposition> {
        return NSFetchRequest<Exposition>(entityName: "Exposition")
    }

    @NSManaged public var code: String?
    @NSManaged public var controlType: Int16
    @NSManaged public var expositionDescription: String?
    @NSManaged public var identifier: String?
    @NSManaged public var maxVisitorsPerGroup: Int64
    @NSManaged public var maxVisitorsPerPeriodWeb: Int64
    @NSManaged public var name: String?
    @NSManaged public var price: Price?
    @NSManaged public var agendas: NSSet?

}

// MARK: Generated accessors for agendas
extension Exposition {

    @objc(addAgendasObject:)
    @NSManaged public func addToAgendas(_ value: Agenda)

    @objc(removeAgendasObject:)
    @NSManaged public func removeFromAgendas(_ value: Agenda)

    @objc(addAgendas:)
    @NSManaged public func addToAgendas(_ values: NSSet)

    @objc(removeAgendas:)
    @NSManaged public func removeFromAgendas(_ values: NSSet)

}
