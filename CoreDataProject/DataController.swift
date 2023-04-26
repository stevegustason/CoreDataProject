//
//  DataController.swift
//  CoreDataProject
//
//  Created by Steven Gustason on 4/26/23.
//

import CoreData
import Foundation

// Create our data controller class, which needs to conform to ObservableObject so we can use the @StateObject property wrapper.
class DataController: ObservableObject {
    // Property which is the Core Data type responsible for loading a data model and giving us access to the data inside
    let container = NSPersistentContainer(name: "CoreDataProject")

    // Initializer to load our data
    init() {
        // If we want Core Data to write changes for duplicate values, we need to adjust the loadPersistentStores() completion handler to specify how data should be merged in this situation
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }

            // This asks Core Data to merge duplicate objects based on their properties - it tries to intelligently overwrite the version in its database using properties from the new version. In our case, because each Wizard has a unique name (which we set up by adding a constraint to our entity), it will try to overwrite the version in the database with the new version.
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
