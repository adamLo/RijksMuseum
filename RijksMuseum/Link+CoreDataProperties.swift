//
//  Link+CoreDataProperties.swift
//  RijksMuseum
//
//  Created by Adam Lovastyik on 12/07/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//
//

import Foundation
import CoreData


extension Link {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Link> {
        return NSFetchRequest<Link>(entityName: "Link")
    }

    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var agenda: Agenda?
    @NSManaged public var artObject: ArtObject?

}
