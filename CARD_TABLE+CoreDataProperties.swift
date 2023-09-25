//
//  CARD_TABLE+CoreDataProperties.swift
//  Gratitude
//
//  Created by Shreyash on 9/24/23.
//
//

import Foundation
import CoreData


extension CARD_TABLE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CARD_TABLE> {
        return NSFetchRequest<CARD_TABLE>(entityName: "CARD_TABLE")
    }

    @NSManaged public var id: String?
    @NSManaged public var cardData: String?
    @NSManaged public var dzImage: Data?
    @NSManaged public var bgImage: Data?

}

extension CARD_TABLE : Identifiable {

}
