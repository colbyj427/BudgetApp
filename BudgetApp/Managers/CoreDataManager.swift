//
//  CoreDataManager.swift
//  BudgetApp
//
//  Created by Colby Johnson on 6/11/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "BudgetModel")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [description]
        }

        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to load Core Data store: \(error)")
            }
        }
    }

    // Preview instance with in-memory store
    static var preview: CoreDataManager = {
        return CoreDataManager(inMemory: true)
    }()
}
//video version

//apple version
// Define an observable class to encapsulate all Core Data-related functionality.
//class CoreDataManager: ObservableObject {
//    static let shared = CoreDataManager()
//    
//    // Create a persistent container as a lazy variable to defer instantiation until its first use.
//    lazy var persistentContainer: NSPersistentContainer = {
//        
//        // Pass the data model filename to the container’s initializer.
//        let container = NSPersistentContainer(name: "BudgetModel")
//        
//        // Load any persistent stores, which creates a store if none exists.
//        container.loadPersistentStores { _, error in
//            if let error {
//                // Handle the error appropriately. However, it's useful to use
//                // `fatalError(_:file:line:)` during development.
//                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
//            }
//        }
//        return container
//    }()
//        
//    private init() { }
//}
