//
//  CoreDataStack.swift
//  ToDoApplication
//
//  Created by Andrey on 05.12.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
        }
        return container

    }
    
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
