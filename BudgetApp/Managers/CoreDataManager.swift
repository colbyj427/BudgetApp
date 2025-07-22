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
