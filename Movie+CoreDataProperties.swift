//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Steven Gustason on 4/26/23.
//
//

// We can generate our own NSManagedObject Subclass by opening the data model inspector, selecting our entity, changing the Codegen to Manual/None then going to Editor > Create NSManagedObject Subclass. This allows us full control over the Class that Swift would normally generate automatically for our data model.


import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    // Note that year is not optional - Core Data will assume a default value for us
    @NSManaged public var year: Int16
    
    // Here, we can add computed properties that help us access the optional values safely, while also letting us store our nil coalescing code all in one place. This makes it so we won't have to manually unwrap every value of our object every time in our code
    public var wrappedTitle: String {
        title ?? "Unknown Title"
    }
    
    public var wrappedDirector: String {
        director ?? "Unknown Director"
    }

}

extension Movie : Identifiable {

}
