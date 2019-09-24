//
//  ExpositionType+CoreDataProperties.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//
//

import Foundation
import CoreData


extension ExpositionType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpositionType> {
        return NSFetchRequest<ExpositionType>(entityName: "ExpositionType")
    }

    @NSManaged public var friendlyName: String?
    @NSManaged public var guid: String?
    @NSManaged public var type: String?
    @NSManaged public var agendas: NSSet?

}

// MARK: Generated accessors for agendas
extension ExpositionType {

    @objc(addAgendasObject:)
    @NSManaged public func addToAgendas(_ value: Agenda)

    @objc(removeAgendasObject:)
    @NSManaged public func removeFromAgendas(_ value: Agenda)

    @objc(addAgendas:)
    @NSManaged public func addToAgendas(_ values: NSSet)

    @objc(removeAgendas:)
    @NSManaged public func removeFromAgendas(_ values: NSSet)

}
