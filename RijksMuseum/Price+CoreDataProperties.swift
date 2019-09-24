//
//  Price+CoreDataProperties.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//
//

import Foundation
import CoreData


extension Price {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Price> {
        return NSFetchRequest<Price>(entityName: "Price")
    }

    @NSManaged public var amount: Double
    @NSManaged public var calculationType: Int64
    @NSManaged public var identifier: String?
    @NSManaged public var expositions: NSSet?

}

// MARK: Generated accessors for expositions
extension Price {

    @objc(addExpositionsObject:)
    @NSManaged public func addToExpositions(_ value: Exposition)

    @objc(removeExpositionsObject:)
    @NSManaged public func removeFromExpositions(_ value: Exposition)

    @objc(addExpositions:)
    @NSManaged public func addToExpositions(_ values: NSSet)

    @objc(removeExpositions:)
    @NSManaged public func removeFromExpositions(_ values: NSSet)

}
