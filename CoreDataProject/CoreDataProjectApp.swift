//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Steven Gustason on 4/26/23.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    // Create an instance of DataController
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Add our data controller to SwiftUI's environment. Managed object context is essentially the live version of our data - when you load objects and change them, those changes only exist in memory until you specifically save them back to the persistent store.
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
