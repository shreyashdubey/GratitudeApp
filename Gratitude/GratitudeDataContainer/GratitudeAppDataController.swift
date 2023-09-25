//
//  GratitudeAppDataController.swift
//  Gratitude
//
//  Created by Shreyash on 9/24/23.
//

import Foundation
import CoreData
import Charts

class GratitudeAppDataController: ObservableObject{
    static let sharedManager: GratitudeAppDataController = {
        return GratitudeAppDataController()
    }()
    
    class func shared() -> GratitudeAppDataController{
        return sharedManager
    }
    
    var container = NSPersistentContainer(name: "GratitudeAppData")
    
    init()
    {
        container.loadPersistentStores { [self]
            description, error in
            
            if let error = error {
                print("Failed to Load the CoreData : \(error.localizedDescription)")
            }
            else {
                print("CoreData loaded Sucessfully")
                let viewContext = container.viewContext
            }
            
        }
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
