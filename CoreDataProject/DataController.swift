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
        // Tells Core Data to access our saved data according to the data model in Bookworm.xcdatamodeld
        container.loadPersistentStores { description, error in
            // If there's an error, print an error message
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
