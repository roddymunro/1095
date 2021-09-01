//
//  CoreDataHelper.swift
//  CoreDataHelper
//
//  Created by Roddy Munro on 2021-09-01.
//

import CoreData

final class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "TravelEntry")
        
        container.persistentStoreDescriptions.first?.url = CoreDataHelper.storeURL
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    private static var storeURL: URL {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.roddy.io.Canada-Citizenship-Countdown")!
        let storeURL = url.appendingPathComponent("CCC.sqlite")
        return storeURL
    }
    
    private init() {}
    
    public func saveContext() {
        context.saveContext()
    }
    
}
