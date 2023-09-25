//
//  DAY_TABLE+CoreDataProperties.swift
//  Gratitude
//
//  Created by Bhavesh Singh on 9/24/23.
//
//

import Foundation
import CoreData


extension DAY_TABLE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DAY_TABLE> {
        return NSFetchRequest<DAY_TABLE>(entityName: "DAY_TABLE")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: String?
    @NSManaged public var cardIDs: NSObject?

}

extension DAY_TABLE : Identifiable {

}
