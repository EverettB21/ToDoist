//
//  Item+CoreDataProperties.swift
//  ToDoist
//
//  Created by Everett Brothers on 10/30/23.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var completedAt: Date?

}

extension Item : Identifiable {

}
