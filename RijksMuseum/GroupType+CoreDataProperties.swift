//
//  GroupType+CoreDataProperties.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 11/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//
//

import Foundation
import CoreData


extension GroupType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupType> {
        return NSFetchRequest<GroupType>(entityName: "GroupType")
    }

    @NSManaged public var friendlyName: String?
    @NSManaged public var guid: String?
    @NSManaged public var type: String?
    @NSManaged public var agenda: Agenda?

}
