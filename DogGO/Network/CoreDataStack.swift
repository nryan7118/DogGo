//
//  CoreDataStack.swift
//  DogGO
//
//  Created by Nick Ryan on 8/29/24.
//

import CoreData
import UIKit

class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    // Add initializer to support both persistent and in-memory stores
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "DogGo")
        
        // Configure lightweight migration for persistent store
        let description = persistentContainer.persistentStoreDescriptions.first
        
        if inMemory {
            // If inMemory is true, use the in-memory store for testing
            let inMemoryDescription = NSPersistentStoreDescription()
            inMemoryDescription.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [inMemoryDescription]
        } else {
            // Allow lightweight migration for persistent store
            description?.shouldMigrateStoreAutomatically = true
            description?.shouldInferMappingModelAutomatically = true
        }
        
        // Load the persistent stores (either in-memory or SQLite)
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func setupAutomaticSaving() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveContext),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveContext),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    @objc private func saveContext() {
        save()
    }
}
