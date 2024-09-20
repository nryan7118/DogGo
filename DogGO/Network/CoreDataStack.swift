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

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "DogGoCore")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persisten stores: \(error)")
            }
        }
    }

    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "DogGoCore")
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        let description = persistentContainer.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true

        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
