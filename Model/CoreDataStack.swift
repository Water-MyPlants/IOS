//
//  CoreDataStack.swift
//  Water da Plants
//
//  Created by Andrew Ruiz on 10/22/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    private init() {}
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WaterDaPlants")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store(s): \(error)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        })
        return container
    }()


    
    var mainContext: NSManagedObjectContext {
          container.viewContext
      }
    
      func saveToPersistentStore() {
          do {
              try mainContext.save()
          } catch {
              NSLog("Error saving context: \(error)")
              mainContext.reset()
          }
      }

    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var saveError: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch {
                saveError = error
                NSLog("Error when saving: \(error)")
            }
        }
        if let saveError = saveError {
            throw saveError
        }
    }
}

